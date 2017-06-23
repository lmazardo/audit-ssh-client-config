# SSH client configuration scanner

Scan an ssh client configuration file to report [good practices](https://stribika.github.io/2015/01/04/secure-secure-shell.html) compliance.

## usage

```bash
./audit-ssh-config.sh [-h] CONFIG_FILE
  --warning = filter messages to *only* display WARNINGs
  --error = filter messages to *only* display ERRORs
  -h = display this help
```


## dev / test

```bash
cd tests/
./bash_unit test_main.sh
```
