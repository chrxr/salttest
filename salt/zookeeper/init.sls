# Check if zookeeper is there:
#   file.missing:
#     - name: /usr/local/zookeeper-3.4.8/bin/zkServer.sh

# DOESN'T SEEM TO BE A WAY TO PREVENT DOWNLOADING THE ARCHIVE EVERY TIME, EVEN IF IT DOESN'T EXTRACT IT

Download and extract Zookeeper:
  archive.extracted:
    - name: /usr/local
    - source: http://mirrors.ukfast.co.uk/sites/ftp.apache.org/zookeeper/zookeeper-3.4.8/zookeeper-3.4.8.tar.gz
    - source_hash: http://apache.org/dist/zookeeper/zookeeper-3.4.8/zookeeper-3.4.8.tar.gz.sha1
    - user: root
    - group: root

Upload zookeeper config:
  file.managed:
    - name: /usr/local/zookeeper-3.4.8/conf/zoo.cfg
    - source: salt://zookeeper/zoo.cfg
    - user: root
    - group: root
    - require:
      - archive: Download and extract Zookeeper

Start/Restart zookeeper:
  cmd.run:
    - name: bin/zkServer.sh restart
    - cwd: /usr/local/zookeeper-3.4.8
    - watch:
      - file: Upload zookeeper config

