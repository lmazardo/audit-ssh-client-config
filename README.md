# SSH client configuration scanner

Scan ssh client configuration file(s) to report [good practices](https://stribika.github.io/2015/01/04/secure-secure-shell.html) compliance.

## usage

```bash
./audit-ssh-config.sh [-h] CONFIG_FILE ...
  --warning = filter messages to *only* display WARNINGs
  --error = filter messages to *only* display ERRORs
  -h = display this help
```

Note that `audit-ssh-config` respects the way the ssh client read the configuration values.
As stated in `man ssh_config`: `For each parameter, the first obtained value will be used.`
Therefore, the order in which you pass the different configuration files to `audit-ssh-config` matters as they will be read in the same order.

## limitations

  * `audit-ssh-config` does not interpret wildcarded hosts: [see #3](https://github.com/multimediabs/audit-ssh-client-config/issues/3)

## dev / test

```bash
cd tests/
./bash_unit {,*/}test_*
```
