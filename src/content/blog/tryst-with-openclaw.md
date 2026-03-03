---
author: pratos
pubDatetime: 2026-03-03T14:24:00Z
title: Tryst with Openclaw
slug: tryst-with-openclaw
featured: false
draft: false
tags:
  - openclaw
  - buildathon
  - agents
description: Reflections from the GrowthX buildathon on learning Openclaw, shipping small tools, and embracing simplicity.
---

 > By **12:30pm** you should have sent at least a "hi" to your bot - Buildathon Host

> By **3:30pm**, I hadn’t even managed to send a single “hi” to my bot. - Me

Wait let's rewind, how did this happen? This is the part where I’m supposed to say the internet was down, or the buildathon rules were unclear, or I was unlucky. But honest to God! I just got humbled.
![pasted-image-20260303200229](@assets/images/blog/tryst-with-openclaw/pasted-image-20260303200229.png)

I came into the GrowthX buildathon confident. Fairly decent engineering, having wrangled a bunch of diverse project, this was supposed to be "I'll build something, not fancy but yes something will be built". But at the back of my mind, I've always had reservations about Openclaw as something you can build on. Being a huge consumer of StarterStory and other solo entrepreneur videos, there were folks hitting 5k, 10k, ... even 50k+ on just letting people install openclaw and anciliary tools. It is crazy.

![pasted-image-20260303162357](@assets/images/blog/tryst-with-openclaw/pasted-image-20260303162357.png)

<blockquote class="twitter-tweet"><a href="https://x.com/RoundtableSpace/status/2028504354026651956?s=20"></a></blockquote>

There's even folks doing openclaw workshops for growth agencies
![pasted-image-20260303162930](@assets/images/blog/tryst-with-openclaw/pasted-image-20260303162930.png)
I’ve built with LangChain, and it put me off completely the first time I looked at the monstrosity. I didn’t want that to happen with OpenClaw. To be fair: OpenClaw is a fundamental shift in how people will build agents — it bubbles up latent model abilities that are now easy to wield (post debacle reflection).

My friend asked me to help him setup his openclaw a couple of week's back, he couldn't. Submitting for the GrowthX buildathon was a way to force myself to at least get some experience under the belt in a focussed environment.

## Background: I/We do not like popular tools
Fatal character flaw as programmers. You can get us to try out an OpenClaw-like tool, and we’ll go ahead and write one from scratch. With models and tools like Claude Code, this delusion has gone to extreme lengths.

But here’s the thing we keep forgetting: **code is fragile**. Writing (or rewriting) software is fun, but maintaining it is hellish. It means more surface area to break, more maintenance, and more time spent debugging. If it is personal software, the graveyard is bigger. Talk to me about the numerous iterations of FPL (Fantasy Premier League) strategy bots I've built over the years without any success.

The best code is code not written — and OpenClaw, used correctly, basically lets you get away with that *scot‑free* as a programmer. You can still ship something useful without rebuilding the world.

I have to constantly remind myself: KISS (keep it stupid simple). Otherwise it’s always this:
![pasted-image-20260303165440](@assets/images/blog/tryst-with-openclaw/pasted-image-20260303165440.png)

And this is the real killer, especially in a buildathon, is **bandwidth**. It’s the most crucial resource — and writing/rewriting things “properly” is a great way to spend it all without shipping. Sad to say, I did that.

The whole GrowthX experience was great! Demos were awesome. But for me it ended in a day's worth of "more" home-manager setup along with openclaw.

## The Aha moments

My approach to build out a  personal daily digest was trying to shoehorn a tool in the Openclaw universe with my prior about writing skills for `pi` agent, which is my daily driver for AI assisted programming. Didn't go well. Generally, tools are in the way of you being productive. Here, I was in the way of Openclaw being productive. Leaping to exploit it rather than explore.

![pasted-image-20260303185210](@assets/images/blog/tryst-with-openclaw/pasted-image-20260303185210.png)

After I stopped trying to force OpenClaw into my old mental models, it became genuinely useful. Not as a aGeNT, but as a practical assistant-with-tools that fits into my life. I just surrendered to it. Felt like using Claude Code for the first time in Sept, 2025.

## Letting Openclaw (Whis) build things
There is a lot of friction in following your interests and sitting down to write software to make that easy. I had a bunch of them I wanted to write. Openclaw runs yolo on my personal Macbook. The setup is still basic, with the standard plugins (`peekabo`, etc) and no extra skills from Clawhub.

- All the secrets are stored in [`sops-nix`](https://github.com/Mic92/sops-nix)
	- [Openclaw nix](https://github.com/openclaw/nix-openclaw) is integrated into my home-manager setup
	- All the API keys and other necessary cli stuff (`github` and `gh` ) can be managed by my bot (still haven't given access)
- All Openclaw agent interactions are saved in Obsidian with full edit access 😬
	![pasted-image-20260303191431](@assets/images/blog/tryst-with-openclaw/pasted-image-20260303191431.png)
	- I've access to my personal obsidian via the bot, so note-taking is easy. Formatting notes is easy!
- Since, `pi` is what powers everything, I've a fair idea on how the multi-turn conversations go. With the new [`acp agents`](https://docs.openclaw.ai/tools/acp-agents), Whis can directly control my `pi` sessions 👀 

1. FPL Assistant
This is the current state of my FPL team
![pasted-image-20260303193035](@assets/images/blog/tryst-with-openclaw/pasted-image-20260303193035.png)
With the new FPL assistant (Still WIP), I can actually think about it reminding me to change teams and give me enough context on how can teams be setup!
- Demo:
	

2. Meme indexer 
I'm an avid collector of memes from X. But I forget where I saved them and never had them handy. Wrote a `uv` one time execution script that doesn't need any stupid setup like the above. The skill automatically indexes the images via CLIP (for now). This was a quick setup, and still some tweaking needs to be done to get a nicer setup. But hey works! 

![pasted-image-20260303190031](@assets/images/blog/tryst-with-openclaw/pasted-image-20260303190031.png)

3. Telegram bot as an editor
Who would have thought, setting up obsidian and give access to it will unlock editor as a service? 

Using `gpt-5.2` , Whis managed to add relevant images. Any new note, is added with relevant context with the Editor skill. Helped with the structure, superflous language and other grammatical mistakes.

![pasted-image-20260303190142](@assets/images/blog/tryst-with-openclaw/pasted-image-20260303190142.png)

4. Daily FOMO resolver (Refactor)
The GrowthX buildathon hosts had asked me a question, what's the `v2` for it (lol @ me). But after I (re)build the `v1`, it basically was to monitor: `X`, `WhatsApp Groups` and `Discord Channels` that have a lot of chatter during the day (no time to read through everything) + night time (US/Europe folks chatter)
At least, hope that I find out a solution to surface quality conversations for myself.

5. Commonplace physical notebooks -> Obsidian
I've 2+ years of extensive notes lying in my notebooks. I've not been able to digitize them and index them in Obsidian. If the Meme indexer tooling is improved, I can definitely do this faster.

## Takeaways
Once the initial hurdle is over, there's still a lot more can be done that I've not thought of! And there's a lot of people doing cool stuff with Openclaw online. I'm still skeptical on whether Openclaw is a good solution for day to day tasks that require rigorous auditing. But there are patterns that can be applied to how we build the next set of `agentic juiced software v3`. 

Thanks to [@udayan_w](https://x.com/udayan_w) and the rest of the organizers (Ganesh, et.al) for organizing Openclaw's Buildathon Mumbai. And [@steipete](https://x.com/steipete) + [@badlogicgames](https://x.com/badlogicgames) for building malleable tooling 🙏   

###  List of brain farts on the blogathon day
- Constantly fixing my "terminal" experience on the blogathon, coz I couldn't get my nix home-manager setup in 2 days.
- I didn't setup openclaw at my end to just get a feel of what's possible.
- Hostinger account panel shit the bed after applying coupon codes and I went ahead deploying an openclaw docker image on fly.io using codex. I was successful by 12:30pm, but I choose to tweak and not git commit the working container.
	- Hostinger had 1-click deploy 💀
