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

Create solr user:
  user.present:
    - name: solr

{% if not salt['file.directory_exists']('/usr/local/solr-6.4.0') %}
Download and extract Solr:
  archive.extracted:
    - name: /usr/local
    - source: http://archive.apache.org/dist/lucene/solr/6.4.0/solr-6.4.0.tgz
    - source_hash: http://archive.apache.org/dist/lucene/solr/6.4.0/solr-6.4.0.tgz.sha1
    - user: solr
    - group: solr
    - enforce_ownership_on: /usr/local/solr-6.4.0
{% endif %}

Upload solrcloud config:
  file.managed:
    - name: /usr/local/solr-6.4.0/bin/solr.in.sh
    - source: salt://solrcloud/solr.in.sh
    - template: jinja
    - user: solr
    - group: solr
    # - require:
    #   - archive: Download and extract Solr

{% if grains['id'] == 'solr1' %}
Make chroot folder in Zookeeper to store Solr stuff:
  cmd.run:
    - name: bin/solr zk mkroot /solr -z {{ salt.pillar.get('zoo_ip')[0] }}:2181
    - cwd: /usr/local/solr-6.4.0
    - creates: /tmp/foo # Creates a file to indicate the command was run sucessfully. If that file exists, will skip the command.
    - watch:
      - file: Upload solrcloud config
{% endif %}

Start / restart SOLR:
  cmd.run:
    - name: bin/solr restart
    - cwd: /usr/local/solr-6.4.0
    - runas: solr
    