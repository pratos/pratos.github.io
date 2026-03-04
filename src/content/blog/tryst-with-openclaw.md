---
author: pratos
pubDatetime: 2026-03-03T14:24:00Z
title: Tryst with Openclaw
slug: tryst-with-openclaw
featured: false
draft: true
tags:
  - openclaw
  - buildathon
  - agents
description: Reflections from the GrowthX buildathon on learning Openclaw, shipping small tools, and embracing simplicity.
---

> By **12:30pm** you should have sent at least a "hi" to your bot — Buildathon Host

> By **3:30pm**, I hadn’t even managed to send a single “hi” to my bot. — Me

Wait, let’s rewind—how did this happen?

This is the part where I’m supposed to say the internet was down, or the buildathon rules were unclear, or I was unlucky. But honest to God: I just got humbled.

![pasted-image-20260303200229](@assets/images/blog/tryst-with-openclaw/pasted-image-20260303200229.png)

I came into the GrowthX buildathon confident. Fairly decent engineering, having wrangled a bunch of diverse projects—this was supposed to be: “I’ll build something. Not fancy, but *something* will be built.”

And yet, at the back of my mind, I’ve always had reservations about OpenClaw as something you can build on.

I’m also a huge consumer of StarterStory and solo‑entrepreneur videos, and I kept seeing folks hit 5k, 10k… even 50k+ just by getting people to install OpenClaw and ancillary tools. It is crazy.

![pasted-image-20260303162357](@assets/images/blog/tryst-with-openclaw/pasted-image-20260303162357.png)

<blockquote class="twitter-tweet"><a href="https://x.com/RoundtableSpace/status/2028504354026651956?s=20"></a></blockquote>

There are even folks doing OpenClaw workshops for growth agencies.

![pasted-image-20260303162930](@assets/images/blog/tryst-with-openclaw/pasted-image-20260303162930.png)

I’ve built with LangChain, and it put me off completely the first time I looked at the monstrosity. I didn’t want that to happen with OpenClaw.

OpenClaw *is* a shift in how people will build agents—it bubbles up latent model abilities that are now easy to wield (post‑debacle reflection).

A friend asked me to help him set up OpenClaw a couple of weeks back. He couldn’t. Submitting for the GrowthX buildathon was my excuse to finally get some reps in, in a focused environment.

## Background: I/We do not like popular tools

Fatal character flaw as programmers. You can get us to try out an OpenClaw‑like tool, and we’ll go ahead and write one from scratch. With tools like Claude Code, this delusion has gone to extreme lengths.

But here’s the thing we keep forgetting: **code is fragile**.

Writing (or rewriting) software is fun. Maintaining it is hellish: more surface area to break, more maintenance, more debugging. If it’s personal software, the graveyard is bigger. Talk to me about the numerous iterations of FPL (Fantasy Premier League) strategy bots I’ve built over the years without any success.

The best code is code not written—and OpenClaw, used correctly, basically lets you get away with that scot‑free. You can still ship something useful without rebuilding the world.

I have to constantly remind myself: KISS (keep it stupid simple). Otherwise it’s always this:

![pasted-image-20260303165440](@assets/images/blog/tryst-with-openclaw/pasted-image-20260303165440.png)

And the real killer—especially in a buildathon—is **bandwidth**. It’s the most crucial resource. Writing/rewriting things “properly” is a great way to spend it all without shipping. Sad to say, I did that.

The whole GrowthX experience was great. Demos were awesome. But for me it ended in a day’s worth of “more” home‑manager setup along with OpenClaw.

## The Aha moments

My plan was to build a personal daily digest by shoehorning OpenClaw into my prior of writing skills for the `pi` agent (my daily driver for AI‑assisted programming). Didn’t go well.

Generally, tools get in the way of you being productive. Here, I was in the way of OpenClaw being productive—leaping to exploit it rather than explore.

![pasted-image-20260303185210](@assets/images/blog/tryst-with-openclaw/pasted-image-20260303185210.png)

Once I stopped forcing OpenClaw into my old mental models, it became genuinely useful. Not as an aGeNT, but as a practical assistant‑with‑tools that fits into my life.

I just surrendered to it. It felt like using Claude Code for the first time in Sept, 2025.

## Letting OpenClaw (Whis) build things

There’s a lot of friction in following your interests and then actually sitting down to write software to make that easy. I had a bunch of things I wanted to build.

Whis runs YOLO on my personal MacBook. The setup is still basic: standard plugins (`peekaboo`, etc.) and no extra skills from Clawhub.

- All the secrets are stored in [`sops-nix`](https://github.com/Mic92/sops-nix)
	- [nix-openclaw](https://github.com/openclaw/nix-openclaw) is integrated into my home‑manager setup
	- All the API keys and other necessary CLI stuff (`github` and `gh`) *can* be managed by my bot (still haven’t given access)
- All OpenClaw agent interactions are saved in Obsidian with full edit access 😬
	![pasted-image-20260303191431](@assets/images/blog/tryst-with-openclaw/pasted-image-20260303191431.png)
	- I have access to my personal Obsidian via the bot, so note‑taking is easy. Formatting notes is easy!
- Since `pi` is what powers everything, I have a fair idea of how multi‑turn conversations go. With the new [`acp agents`](https://docs.openclaw.ai/tools/acp-agents), Whis can directly control my `pi` sessions 👀

There’s always something to build—too many ideas that were shelved because I didn’t have the bandwidth. These are a few that feel possible to do well *without* me sitting down with `pi` and writing a specialized tool for each (which I’ll forget to use).

1. **FPL Assistant**

   This is the current state of my FPL team:

   ![pasted-image-20260303193035](@assets/images/blog/tryst-with-openclaw/pasted-image-20260303193035.png)

   With the new FPL assistant (still WIP), I can actually imagine it reminding me (weekly) to change teams and giving me enough context on how teams can be set up.

   Right now, a friend reminds us in the group and I still don’t update our teams 😭

   - Demo:

2. **Meme indexer**

   I’m an avid collector of memes from X. But I forget where I saved them and never have them handy.

   I wrote a one‑time execution `uv` script that doesn’t need any stupid setup like the above. The skill automatically indexes the images via CLIP (for now).

   Quick setup, still needs tweaking—but hey, it works.

   ![pasted-image-20260303190031](@assets/images/blog/tryst-with-openclaw/pasted-image-20260303190031.png)

3. **Telegram bot as an editor**

   Who would have thought: setting up Obsidian and giving access to it would unlock editor‑as‑a‑service?

   Using `gpt-5.2`, Whis managed to add relevant images. Any new note is added with relevant context using the Editor skill. It helped with structure, superfluous language, and other grammatical mistakes.

   ![pasted-image-20260303202620](@assets/images/blog/tryst-with-openclaw/pasted-image-20260303202620.png)

   Suggestions added in Obsidian for future reference:

   ![pasted-image-20260303202535](@assets/images/blog/tryst-with-openclaw/pasted-image-20260303202535.png)

4. **Daily FOMO resolver (refactor)**

   The GrowthX buildathon hosts asked me a question: what’s the `v2` for it (lol @ me).

   After I (re)built the `v1`, it basically was to monitor: `X`, `WhatsApp Groups`, and `Discord Channels` that have a lot of chatter during the day (no time to read through everything) + night time (US/Europe folks chatter).

   At least, I hope I find a solution to surface quality conversations for myself.

5. **Commonplace physical notebooks → Obsidian**

   I’ve got 2+ years of extensive notes lying in my notebooks. I haven’t been able to digitize them and index them in Obsidian.

   If the meme‑indexer tooling improves, I can definitely do this faster.

## Takeaways

Once the initial hurdle is over, there’s still a lot more that can be done that I haven’t thought of yet—and there are a lot of people doing cool stuff with OpenClaw online.

I’m still skeptical about whether OpenClaw is a good solution for day‑to‑day tasks that require rigorous auditing. But there are patterns here that can be applied to how we build the next set of agentic, juiced software (v3).

Thanks to [@udayan_w](https://x.com/udayan_w) and the rest of the organizers (Ganesh, et al.) for organizing OpenClaw’s Buildathon Mumbai. And [@steipete](https://x.com/steipete) + [@badlogicgames](https://x.com/badlogicgames) for building malleable tooling 🙏

### List of brain farts on the buildathon day

- Constantly fixing my “terminal” experience on the buildathon, because I couldn’t get my nix home‑manager setup in 2 days.
- I didn’t set up OpenClaw locally to just get a feel for what’s possible.
- Hostinger account panel shit the bed after applying coupon codes, and I went ahead deploying an OpenClaw docker image on fly.io using Codex. I was successful by 12:30pm, but I chose to tweak and not git commit the working container.
	- Hostinger had 1‑click deploy 💀
- I optimized for **outputs** instead of **outcomes**. I wanted artifacts. I wanted “look what I built.” What I should have shipped was simple: a personal daily digest agent.

---

## 🟨 Edit highlights + comments (for future passes)

> [!note] Consistency
> ==buildathon / blogathon== → I standardized on **buildathon** throughout.

> [!note] Spelling/wording
> ==anciliary== → **ancillary**
>
> ==superflous== → **superfluous**

> [!note] Product naming
> ==peekabo== → assumed you meant **peekaboo** (the plugin).

> [!note] Grammar
> ==a couple of week's back== → **a couple of weeks back**
>
> ==help him setup== → **help him set up**

> [!note] Tone (keep vs tweak)
> You use “YOLO” + “shit the bed” + “lol @ me”—it works for a personal blog voice. If you ever repurpose this for LinkedIn, I’d keep the honesty but swap those phrases for milder versions.
