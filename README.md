# DevOps Intern Assignment – Powerplay

This repository contains my completed DevOps Internship Assignment completed on an Ubuntu EC2 instance in AWS (region: eu-north-1).

## Part 1 – Environment Setup

![Part 1 Setup](https://raw.githubusercontent.com/Amartypes/devops-internship-powerplay/main/screenshots/part1_setup.png)

- Created user `devops_intern`, granted passwordless sudo, changed hostname.
- Verified with:
  ```
  hostname
  grep devops_intern /etc/passwd
  sudo whoami
  ```

## Part 2 – Web Service

![Part 2 Webpage](https://raw.githubusercontent.com/Amartypes/devops-internship-powerplay/main/screenshots/part2_webpage.png)

- Installed Nginx, fetched instance metadata via IMDSv2, created custom index.html.

## Part 3 – Monitoring Script & Cron

![Part 3 Cron](https://raw.githubusercontent.com/Amartypes/devops-internship-powerplay/main/screenshots/part3_cron.png)

![Part 3 Log 1](https://raw.githubusercontent.com/Amartypes/devops-internship-powerplay/main/screenshots/part3_log1.png.png)

![Part 3 Log 2](https://raw.githubusercontent.com/Amartypes/devops-internship-powerplay/main/screenshots/part3_log2.png.png)

Script: `/usr/local/bin/system_report.sh`
Cron:
```
*/5 * * * * /usr/local/bin/system_report.sh
```

## Part 4 – CloudWatch Integration

![AWS CLI](https://raw.githubusercontent.com/Amartypes/devops-internship-powerplay/main/screenshots/part4_awscli.png)

AWS CLI commands used:
```
aws logs create-log-group --log-group-name /devops/intern-metrics --region eu-north-1
aws logs create-log-stream --log-group-name /devops/intern-metrics --log-stream-name ec2-system-report --region eu-north-1
```
![CloudWatch Logs](https://raw.githubusercontent.com/Amartypes/devops-internship-powerplay/main/screenshots/part4_cloudwatchlogs.png)

Payload creation:
```
TIMESTAMP_MS=$(($(date +%s) * 1000))
LOG_LINE=$(grep -v '^$' /var/log/system_report.log | tail -n 1)
cat <<EOF > log.json
[
  {
    "timestamp": $TIMESTAMP_MS,
    "message": "$LOG_LINE"
  }
]
EOF
```

Upload:
```
aws logs put-log-events --log-group-name /devops/intern-metrics --log-stream-name ec2-system-report --log-events file://log.json --region eu-north-1
```

## Part 5 – Cleanup
Terminated EC2 instance, prepared repo with all files.
