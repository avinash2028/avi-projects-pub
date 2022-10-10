#!/bin/bash
# Check status of elk
service=(elasticsearch kibana apm-server)
elk_service() {
        for ((i=0;i<${#service[@]};i++))
        do
          /etc/init.d/${service[$i]} $1
          service logstash $1
        done

}
elk_service
