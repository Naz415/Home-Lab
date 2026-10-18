---
layout: page
title: Journal
permalink: /journal/
---

Dated lab-notebook entries, oldest first. Each one names the decision record or
commit it belongs to. The source files are in
[`_posts/`](https://github.com/Naz415/Home-Lab/tree/main/_posts).

{% assign entries = site.posts | reverse %}
{% for post in entries %}
- **{{ post.date | date: "%-d %B %Y" }}** — [{{ post.title }}]({{ post.url | relative_url }})
{% endfor %}
