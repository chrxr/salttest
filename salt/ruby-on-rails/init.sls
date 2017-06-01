Install packages:
  pkg.installed:
    - pkgs:         
      {% if grains['os_family'] == 'RedHat' %}
      {% for package in pillar.get('redhat_packages', {}) %}
      - {{ package }}
      {% endfor %}
      {% elif grains['os_family'] == 'Debian' %}
      {% for package in pillar.get('ubuntu_packages', {}) %}
      - {{ package }}
      {% endfor %}
      {% endif %}

clone rbenv:
  git.latest:
    - name: https://github.com/rbenv/rbenv.git
    - target: /usr/local/.rbenv/
    

Upload .bashrc config to add rbenv to path:
  file.managed:
    - name: ~/.bashrc
    - source: salt://ruby-on-rails/.bashrc
    - template: jinja

Test .rbenv:
  cmd.run:
    - name: 
    - cwd: ~