# Simulating DNS Changes

## Requirements

- Requires an AWS account with a hosted zone
- Export `TF_VAR_zone_name` into shell (e.g. `example.com`)

## Usage

- Create EC2 instances using `terraform apply`
- Bring up HAProxy via `docker-compose up`
- Poll proxy endpoint using `poll.sh`
- Simulate DNS change by re-running `terraform apply`
- Will randomly select an EC2 instance to point domain to
- HAProxy resolver should pick up the IP change w/o disruption

## Example

- Output from HAProxy resolver:

```txt
haproxy_1  | [WARNING] 041/141511 (7) : default/backend1 changed its IP from 1.2.3.4 to 5.6.7.8 by my-dns/127.0.0.11.
```

- Polling script output:

```sh
[1549894508] <h1>i-0023760be3ec39ff9</h1>
[1549894509] <h1>i-0023760be3ec39ff9</h1>
[1549894510] <h1>i-0023760be3ec39ff9</h1>
[1549894512] <h1>i-05d71aa6026d87e92</h1>
[1549894513] <h1>i-05d71aa6026d87e92</h1>
```
