# Install packages:
#   pkg.installed:
#     - pkgs:         
#       {% if grains['os_family'] == 'RedHat' %}
#       {% for package in pillar.get('redhat_packages', {}) %}
#       - {{ package }}
#       {% endfor %}
#       {% elif grains['os_family'] == 'Debian' %}
#       {% for package in pillar.get('ubuntu_packages', {}) %}
#       - {{ package }}
#       {% endfor %}
#       {% endif %}

# Download and extract Solr:
#   archive.extracted:
#     - name: /usr/local
#     - source: http://archive.apache.org/dist/lucene/solr/6.4.0/solr-6.4.0.tgz
#     - source_hash: http://archive.apache.org/dist/lucene/solr/6.4.0/solr-6.4.0.tgz.sha1
#     - user: root
#     - group: root

Upload solrcloud config:
  file.managed:
    - name: /usr/local/solr-6.4.0/bin/solr.in.sh
    - source: salt://solrcloud/solr.in.sh
    - template: jinja
    - user: root
    - group: root
    # - require:
    #   - archive: Download and extract Solr
