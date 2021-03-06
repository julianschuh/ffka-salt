install fastd:
  pkg.latest:
    - name: fastd


{% for interfaces in salt['pillar.get']('mesh_vpn:fastd:interfaces') %}

Fastd config file {{ interfaces.name }}:
  file.managed:
    - name: /etc/fastd/{{ interfaces.name }}/fastd.conf
    - source: salt://mesh_vpn/files/fastd.j2
    - makedirs: true
    - user: root
    - group: root
    - mode: 660
    - template: jinja
    - context:
        name: "{{ interfaces.name }}"
        bind: "{{ interfaces.bind }}"
        mac: "{{ interfaces.mac }}"

Fastd secret {{ interfaces.name }}:
  file.managed:
    - name: /etc/fastd/{{ interfaces.name }}/secret.conf
    - source: salt://mesh_vpn/files/secret.conf
    - makedirs: true
    - user: root
    - group: root
    - mode: 660
    - template: jinja

enable/run systemd {{ interfaces.name }}:
  service.running:
    - name: fastd@{{ interfaces.name }}
    - enable: true
    - watch:
      - file: /etc/fastd/{{ interfaces.name }}/fastd.conf
{% endfor %}
