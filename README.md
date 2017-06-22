# SSH client configuration scanner

Scan an ssh client configuration file to report [good practices](https://stribika.github.io/2015/01/04/secure-secure-shell.html) compliance.

## usage

```bash
git clone git@github.com:Pamplemousse/audit-ssh-client-config.git
cd audit-ssh-client-config
./main CONFIG_FILE
```


## dev / test

```bash
cd tests/
./bash_unit test_main.sh
```
