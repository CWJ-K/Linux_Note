<!-- omit in toc -->
# Introduction

<br />

<!-- omit in toc -->
# Table of Contents

<br />

# Fundamental Concepts
## service
* always provides service for users
  * e.g. provide cron jobs
* different from bash
  * if you want to make a service
    * write a bash script: <file>.sh
    * change the permission to `a+x`
      * must `x`
    * create a service script: /etc/systemd/system/<file>.service
      * format
        ```bash
          [Unit]
          Description=backup my server
          Requires=atd.service  # since ExecStart uses `at`

          [Service]
          Type=simple
          ExecStart=/bin/bash -c " echo /backups/backup.sh | at now"

          [Install]
          WantedBy=multi-user.target
        
        ```
    * systemctl daemon-reload
    * systemctl start backup.service

## daemon
* a program to execute the service
  * <filename>d
  * every service have a daemon for execution

## systemd 
* use systemd to manage services
  * command: systemctl 
* used in memory => on-demand
* call the scripts executed by daemon "unit"
* configuration files
  * /usr/lib/systemd/system/: systemd activates scripts
  * /run/systemd/system/
  * /etc/systemd/system/: includes many linked files

* types of unit
  * see `ll /usr/lib/systemd/system/`
  * table of types
    |Type|Meaning|
    |:---:|:---|
    |.service|common service type|
    |.socket||
    |.target|a collection of units: execute many services or sockets|
    |.mount; .automount||
    |.path|specific file or directory|
    |.timer|like cronjob, but provided by systemd|

<br />

# Commands 

## systemctl
* there are two ways to execute the service
  * when the machine boots, the services are also executed
  * users decide to execute the service
* use `systemctl` to stop the service instead of kill, which users can not monitor the service
```bash
    systemctl [command] [unit]

    systemctl status atd.service

    # can stop the services, including dependent services
    systemctl unmask [unit]

    systemctl show

```

* types of active
  |Types|Meaning|
  |:---:|:---|
  |active (running)|services are running|
  |active (exited)|services only run once. There are no running services|
  |active (waiting)|waiting other services|
  |inactive|the service is not active|

* types of status in daemon
  |Types|Meaning|
  |:---:|:---|
  |enabled|the daemon will be executed when booting|
  |disabled|the daemon will not be executed when booting|
  |static|can not enable, but can be enabled by other services|
  |mask|can not enable anymore|

### check all services


```bash
    systemctl [command] [--type=TYPE] [--all]

    systemctl list-unit-files

    systemctl list-units --type=service --all

    systemctl list-units --type=service --all | grep cpu

```

### manage different target units

```bash
    systemctl list-units --type=target --all
    systemctl get-default
    systemctl set-default multi-user.target

    # reobtain graphical.target
    systemctl isolate graphical.target

    systemctl poweroff
    systemctl reboot

    # store data of systems in memory
    systemctl suspend 

    # store data of systems in disk
    systemctl hibernate

    systemctl rescue
    systemctl emergency 
```

### find the dependencies of services

```bash
    systemctl list-dependencies [unit] [--reverse]
    # --reverse: reverse to find the dependencies of services

```

### find the path of services

```bash
    systemctl list-sockets

```


### list the port of services
* ip is like your home. ports are the floors of your home
* protocol: define specific floors for specific services
  * WWW, httpd = 80. So www can connect with httpd


```bash 
    cat /etc/services

```

### disable the internet service
* internet service: the service with port
* if the internet service is not essential, disable it
```bash
  # see the current internet service
  netstat -tlunp

  # check the specific service with the internet
  systemctl list-units --all | grep <service>

  # disable the services
  systemctl stop <service>.service
  systemctl stop <service>.socket
  systemctl disable <service>.service <service>.socket



  netstat -tlunp
```

### timer - for cronjob
* except for `crond`, `timer` also can do cronjob
  * logs generated by `systemctl` will be saved => debug becomes easier
  * `timer` can combine with `systemctl`
  * `timer` can combine with `cronjob`
* prerequisites:
  * `timer.target` must be activated
  * `<service_name>.service` must exist
  * `<service_name>.timer` must exist

* created via `/etc/systemd/system/<service_name>.timer`
  * contents
    |configurations|meaning|
    |:---:|:---|
    |OnActiveSec|when executing this timer after activating it|
    |OnBootSec|when executing this timer after booting|
    |OnStartupSec|when executing this timer after activating systemctl the first time|
    |OnUnitActiveSec|when the unit.service in the timer is activated from the last time it is activated|
    |OnUnitInactiveSec|when the unit.service in the timer is activated from the last time it is inactivated|
    |OnCalendar|use real time to activate services|
    |Unit||
    |Persistent|whether OnCalendar continues to use|

* the format of `timer`
  * the timer is executed 2 hours after boot
  * after boot of the first time, every 2 days runs the timers
  ```bash
    [Unit]
    Description=backup my server timer

    [Timer]
    OnBootSec=2hrs
    OnUnitActiveSec=2days

    [Install]
    WantedBy=multi-user.target
  
  ```

#### OnCalendar
  * format
    * the smaller unit is written in front of the bigger unit
    * the format of period
      * us of usec
      * ms of msec
      * s, sec, second, seconds
      * m, min, minute, minutes
      * h, hr, hour, hours
      * d, day, days
      * w, week, weeks
      * month, months
      * y, year, years
    * the format of the representation of time. If now: 2015-08-13 13:50:00:
      > year-month-day hour-minute-second
      * now	Thu 2015-08-13 13:50:00*
      * today	Thu 2015-08-13 00:00:00*
      * tomorrow	Thu 2015-08-14 00:00:00*
      * hourly	*-*-* *:00:00*
      * daily	*-*-* 00:00:00*
      * weekly	Mon *-*-* 00:00:00*
      * monthly	*-*-01 00:00:00*
      * +3h10m	Thu 2015-08-13 17:00:00*
      * 2015-08-16	Sun 2015-08-16 00:00:00*

```bash
  systemctl dameon-reload
  systemctl enable backup.timer
  systemctl restart backup.timer

  ## only enable timer instead of service (to be executed)
  systemctl list-unit-files | grep backup

  # target manage timers
  systemctl show timers.target

  # the difference between the last execution time of timers.target
  ## if OnCalendar: the difference between 1970-01-01 00:00:00
  systemctl show backup.timer

```