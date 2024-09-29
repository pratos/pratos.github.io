---
author: pratos
pubDatetime: 2023-01-30T15:57:52.737Z
title: returns and fun(k)c in Python
slug: returns-python
featured: false
ogImage: https://user-images.githubusercontent.com/53733092/215771435-25408246-2309-4f8b-a781-1f3d93bdf0ec.png
tags:
  - release
description: This is a personal experience of using returns and trying to learn functional programming paradigms in Python (in a professional setting).
---

### Python & Functional Programming
Python doesn't let you write functional code out of the box. There's a good chance, the "functional" code you might write isn't functional. I'm definitely not here to discuss the intricacies of functional programming, just the experiences.

We are aware of map, filter, functools, itertools and lots of other niceties, which proxies for leveraging nicer parts of functional programming APIs. These let you do the functional things. But I wanted to satisfy my itch for abstractions that would help me leverage functional paradigms more accessibly (maybe?). This led me to returns.

### Did returns have returns?
First impressions and Railway Oriented Programming Pattern
returns is a nifty library that helps by providing functional constructs to help write "better" pythonic, functional code.

I was fascinated by Railway Oriented Programming (ROP) Pattern and wanted to handle Exceptions in a friendly way. Exception Handling is a real pain, when you want to make sure that the right messages and error code bubble up from the deep recesses of your controllers and services.

When an opportunity arose, I jumped at using returns. As a team, we had planned to use returns, but our attempts were half hearted at best. Using returns was a rocky, but enlightening experience.

Though I can't reveal the actual code, let me take you through a usage for returns. But first a tldr on Railway Oriented Programming Pattern

Many examples in functional programming assume that you are always on the “happy path”. But to create a robust real world application you must deal with validation, logging, network and service errors, and other annoyances. So, how do you handle all this in a clean functional way? - F# For Fun and Profit

<image src="https://miro.medium.com/max/1400/1*6bzo0qxaFYMCfYGuz7O4qw.png"/>

In short, ROP tells us to:

Create some sort of Result type that defines a 2 Track Output == Union[Success, Failure]
Use a bind function to convert all our functions to a two track output (even if they can't throw errors)
Compose all your functions via pipes
Add nice Error types as your write and refactor your code to handle those pesky Failures
returns provides all of that in nicely packages containers with similar names like Result, Success and Failure (There's more but for scope we won't be covering the rest). returns readme has an excellent example on how to use those, the example used here is a modfied version.

### Problem statement to solve
We'll be fetching data from football (soccer 👀) player data from fbref. We'll be extracting the data from html tables on the page and store it in a csv. Let's start by fetching Arsenal's 2022-23 season data via this url: link

Let's layout the steps that we'll need to perform inorder to get from our html page to a csv:

Fetch the html content via requests
Convert the html content to a BeautifulSoup for further extraction
Extract all the tables and combine all the statistics into one table
Save the table to a csv
To simplify a few steps and for brevity, we'll be skipping a lot of the stats mapping code.

Make sure you install returns in your venv.

```python
import sys
sys.version
'3.10.4 (main, Jun  1 2022, 18:38:27) [Clang 13.0.1 ]'
```

Below is the code to parse data, you can skip this if you like

```python
import requests
from bs4 import BeautifulSoup
from loguru import logger
from returns.result import Result, Success, Failure

def formatter(v: int|float) -> int|float:
    if not v:
        return 0.0
    return literal_eval(v)

from enum import Enum
from typing import Literal, List
class TableId(Enum):
    standard_stats = "stats_standard_9"

    def __str__(self):
        return self.value

from pydantic import BaseModel, validator
from ast import literal_eval

Nation = Literal["ENG", "FRA", "BRA", "NOR", "SUI", "UKR", "GHA", "SCO", "BEL", "EGY", "JPN",
                "POR", "CIV", "USA"]
Position = Literal["GK", "DF", "MF", "FW"]

class Age(BaseModel):
    year: int
    months: int

    @validator("*", pre=True, always=True)
    def formatter(cls, v):
        if not v:
            return 0.0
        return literal_eval(v.lstrip("0"))

    @validator("months", always=True)
    def age_convertor(cls, v):
        return round(v / 30, 0)

class BasicProfile(BaseModel):
    player_name: str
    nation: Nation
    position: List[Position]
    age: Age


class PlayingTime(BaseModel):
    matches_played: int
    minutes_played: int
    starts: int
    nineties: int

    _formatter = validator("*", pre=True, allow_reuse=True)(formatter)


class Performance(BaseModel):
    goals_scored_or_allowed: int
    assists: int
    non_penalty_goals: int
    penalties: int
    yellow_cards: int
    red_cards: int

    _formatter = validator("*", pre=True, allow_reuse=True)(formatter)

class PerformancePer90(BaseModel):
    goals: float
    assists: float

    _formatter = validator("*", pre=True, allow_reuse=True)(formatter)

class XPPerformance(BaseModel):
    expected_goals: float
    non_penalty_expected_goals: float
    expected_assists: float
    non_penalty_goals_expected_and_assists: float

    _formatter = validator("*", pre=True, allow_reuse=True)(formatter)

class XPPerformancePer90(XPPerformance):
    pass


class StandardStats(BaseModel):
    player_profile: BasicProfile
    playing_time_overall: PlayingTime
    player_performance: Performance
    player_performance_per_90: PerformancePer90
    player_xp: XPPerformance
    player_xp_per_90: XPPerformancePer90

arsenal_url = "https://fbref.com/en/squads/18bb7c10/Arsenal-Stats"
#collapse-hide
def fetch_html_content(url: AnyHttpUrl) -> BeautifulSoup:
    resp = requests.get(url, timeout=20)
    return BeautifulSoup(resp.content, "html.parser")

html_data = fetch_html_content(url=arsenal_url)

* Extracting all the tables
    - We'll just extract one for brevity
    - Excuse the multiple list comprehensions, isn't optimized 😬

#collapse-hide
def extract_and_format_fbref_data(table_id: TableId, html_data: BeautifulSoup) -> List[StandardStats]:
    standard_stats_list = []
    standard_stats_table = html_data.find(id=table_id)
    standard_stats_table.find_all("caption")[0].text
    table_headers = [row.text.lower() for row in standard_stats_table.find_all("tr")[1] if row != ' ']
    table_data = standard_stats_table.find_all("tbody")[0]
    for idx, row in enumerate(table_data.find_all("tr")):
        stripped_data = [data.text for data in row]
        age = Age(
            year=stripped_data[3].split("-")[0],
            months=stripped_data[3].split("-")[1]
        )
        basic_profile = BasicProfile(
            age=age,
            player_name=stripped_data[0],
            nation=stripped_data[1].split(" ")[1],
            position=[pos.strip() for pos in stripped_data[2].split(",")]
        )
        playing_time = PlayingTime(
            matches_played=stripped_data[4],
            starts=stripped_data[5],
            minutes_played=stripped_data[6],
            nineties=stripped_data[7]
        )
        performance = Performance(
            goals_scored_or_allowed=stripped_data[8],
            assists=stripped_data[9],
            non_penalty_goals=stripped_data[10],
            penalties=stripped_data[11],
            yellow_cards=stripped_data[13],
            red_cards=stripped_data[14]
        )
        performance_per90 = PerformancePer90(
            goals=stripped_data[15],
            assists=stripped_data[16],
        )
        xp_performance = XPPerformance(
            expected_goals=stripped_data[20],
            non_penalty_expected_goals=stripped_data[21],
            expected_assists=stripped_data[22],
            non_penalty_goals_expected_and_assists=stripped_data[23],
        )
        xp_performance_per90 = XPPerformancePer90(
            expected_goals=stripped_data[24],
            non_penalty_expected_goals=stripped_data[25],
            expected_assists=stripped_data[26],
            non_penalty_goals_expected_and_assists=stripped_data[27],
        )
        standard_stats = StandardStats(
            player_profile=basic_profile,
            playing_time_overall=playing_time,
            player_performance=performance,
            player_performance_per_90=performance_per90,
            player_xp=xp_performance,
            player_xp_per_90=xp_performance_per90
        )
        standard_stats_list.append(standard_stats)
    return standard_stats_list

parsed_data = extract_and_format_fbref_data(table_id=TableId.standard_stats.value, html_data=html_data)

import csv
import json

class JsonWriter:
    def __init__(self, path: str, data: List[StandardStats]):
        self._path = path
        self._data = data

    def save(self) -> None:
        with open(self._path, "w", newline="") as json_file:
            json.dump([stat.dict() for stat in self._data], json_file)

def save_data(writer: CSVWriter | JsonWriter, path: str, data: List[StandardStats]) -> str:
    writer_inst = writer(path=path, data=data)
    writer_inst.save()
    return `f"Successfully saved data to {path}"`

save_data(JsonWriter, path="../data/arsenal_standard_stats.json", data=parsed_data)
```

### How do we bind these and make sure that we follow ROP?
Two magic keywords: `@safe`(and/or its variant @impure_safe) and `flow` (or pipe).

- `@safe` is basically an exception handler decorator. Any exception caught will return a Failure container. For the happy path, we'd have Success container with our output
There's also `@impure_safe` which is a more explicit way to tell readers that this piece of code might fail or result might be different for the same request. DB Query, API calls, etc
- `flow` (or `pipe`) act as pipelines for stiching functions together using bind.

```python
from returns.pipeline import flow
from returns.pointfree import bind
from returns.result import safe
from returns.io import impure_safe, IOResult
from returns.curry import curry

@impure_safe
def fetch_html_content(url: AnyHttpUrl) -> BeautifulSoup:
    resp = requests.get(url, timeout=20)
    return BeautifulSoup(resp.content, "html.parser")

@safe
def extract_and_format_fbref_data(table_id: TableId, html_data: BeautifulSoup) -> List[StandardStats]:
    standard_stats_list = []
    ...
    return standard_stats_list

@safe
def save_data(writer: CSVWriter | JsonWriter, path: str, data: List[StandardStats]) -> str:
    writer_inst = writer(path=path, data=data)
    writer_inst.save()
    return `f"Successfully saved data to {path}"`

def fetch_standard_stats(url: AnyHttpUrl, table_id: TableId, output_path: str) -> IOResult[Success, Failure]:
    return flow(
        url,
        fetch_html_content,
        bind(partial(extract_and_format_fbref_data, table_id)),
        bind(partial(partial(save_data, JsonWriter), output_path))
    )
```

Let me lay out the flow pipeline in `fetch_standard_stats`:
- flow is a pipeline that takes in the attribute(s) (url here) for the first function: fetch_html_content.
- The first function throws out a Success container (if no exceptions) that is consumed by extract_and_format_fbref_data. Since the 2nd function has multiple arguments, we are using partial to bind together arguments.
- bind(partial(extract_and_format_fbref_data, table_id))

Above is equivalent to:
```python
function_1 = partial(extract_and_format_fbref_data, table_id)
function_2 = bind(function_1, 'Success: html_data')
```

function_2 above will emit: Success: parsed_data which would be input for the next bind function.

A successful outcome would be as below
```python
fetch_standard_stats(
    arsenal_url,
    TableId.standard_stats,
    "../data/arsenal_standard_stats.json"
)
&lt;Success: Successfully saved data to ../data/arsenal_standard_stats.json&gt;
```

If we mess up something in the arsenal_url? Let's check what the output would be:
```python
fetch_standard_stats("https://localhost:9200")
&lt;Failure: HTTPSConnectionPool(host='localhost', port=9200): Max retries exceeded with url: / (Caused by SSLError(SSLError(1, '[SSL: WRONG_VERSION_NUMBER] wrong version number (_ssl.c:997)'))&gt;
```

As expected, we get a HTTPSConnectionPool error that we get out without writing excessive try-catch blocks. We can easily bubble these errors 2-3 levels up using bindings and making the code cleaner.

At any step of the pipeline, Failure container would throw a nice message and we can do the rest. Obviously, there's a few more nuanced implementations for complex pipelines. E.g. While doing a DB operation if the query sends no result or API request is unsuccessful with a valid status code. All those might need more rejig of the code.

### How do we fetch the output from `Success` container?
In our case, the final step throws a `Success` container with response str embedded. If we want to send this result back via API or do another set of operations on it, it is easy to do with `result._inner_value`

```python
success_result = fetch_standard_stats(
    arsenal_url,
    TableId.standard_stats,
    "../data/arsenal_standard_stats.json"
)
success_result._inner_value
'Successfully saved data to ../data/arsenal_standard_stats.json'
```

`._inner_value` could be anything that you want to share: `dict, str, Object, Query row, json`. This opens up a lot of avenues to play around with pydantic Models or dataclasses that help standardize API responses, sql orm models!

### Is is any good to use?
`returns` doesn't have a great documentation. It would be hard to blame the maintainers coz one needs to atleast understand basics of functional programming (currying, partial, Optional, Maybe containers). A comprehensive documentation/examples about more real life usage could help more non-chad devs like us.

Combined with OOPS, returns would definitely be an alternative to write cleaner, readable code. One could also ditch returns entirely and work with functools, dataclasses and types in python to write similar helpers, decorators in vanilla python. Maybe that could be another blog post.

The above code surely can be much better, still improving on how to write code. Would love to hear feedback on the code and this blogpost!

### Appendix
- [Railway Oriented Programming Pattern](https://fsharpforfunandprofit.com/posts/recipe-part2/)
- [Railway Oriented Programming Pattern Slides](https://www.slideshare.net/ScottWlaschin/railway-oriented-programming)
- [dry-python/returns](https://github.com/dry-python/returns)
- [Dry Ruby -- dry-rb](https://dry-rb.org/)
- [Excellent talk on using dry-rb](https://www.youtube.com/watch?v=YXiqzHMmv_o)
- [Functional programming: Computerphile](https://www.youtube.com/watch?v=LnX3B9oaKzw)
- [functools.partial](https://docs.python.org/3/library/functools.html#functools.partial)
- [3 Simple ideas from functional programming to improve your code - Arjan Codes](https://www.youtube.com/watch?v=4B24vYj_vaI)
- [Functional Programming in Python: Currying](https://www.youtube.com/watch?v=yk-IXz0DjTY)