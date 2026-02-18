---
layout: page
permalink: /repositories/
title: repositories
nav: true
nav_order: 3
---

{% if site.data.repositories.github_users %}
<div class="repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
  {% for user in site.data.repositories.github_users %}
    {% include repository/repo_user.html username=user %}
  {% endfor %}
</div>
{% endif %}

## GitHub Repositories

{% if site.data.repositories.github_repos %}
<div class="repositories-grid">
  {% for repo in site.data.repositories.github_repos %}
    {% assign repo_parts = repo | split: '/' %}
    {% assign repo_owner = repo_parts[0] %}
    {% assign repo_name = repo_parts[1] %}
    {% include repository/repo_card.html repo=repo owner=repo_owner name=repo_name %}
  {% endfor %}
</div>
{% endif %}

