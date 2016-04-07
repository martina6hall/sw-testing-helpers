---
layout: default
---

URL: {{ site.github.url }}

{% assign staticFiles = site.static_files | sort: 'path' | reverse%}
{% assign currentSectionName = '' %}
{% assign currentVersionName = '' %}

{% for file in staticFiles %}
  {% if file.extname != '.html' %}
    {% continue %}
  {% endif %}

  {% if pathParts[1] != 'docs' %}
    {% continue %}
  {% endif %}

  {% comment %}
    The first forward slash in the path means pathParts[0] == ''
  {% endcomment %}
  {% assign pathParts = file.path | split: '/' %}
  {% assign tempSectionName = pathParts[2] %}

  {% if currentSectionName != tempSectionName %}
    {% assign currentSectionName = tempSectionName %}
    {% if currentSectionName == 'master' %}
# Master Branch
    {% else %}
# {{currentSectionName | capitalize}}
    {% endif %}
  {% endif %}

  {% if pathParts.last == 'index.html' %}
    {% if pathParts.size == 4 %}
[View the docs for {{currentSectionName | capitalize}}]({{ file.path | prepend: site.github.url }})
    {% elsif pathParts.size == 5 %}
[View the docs for {{ site.github.project_title }} {{ pathParts[3] }}]({{ file.path | prepend: site.github.url }})
    {% endif %}
  {% endif %}
{% endfor %}