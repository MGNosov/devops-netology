Домашенее задание к занятию "2.4. Инструменты GIT". Носов Максим.
1. commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
2. commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)
3. Два родителя  
   commit 56cd7859e05c36c06b56d013b55a252d0bb7e158
   commit 9ea88f22fc6269854151c571162c5bcf958bee2b 
4. b14b74c49 [Website] vmc provider links
   3f235065b Update CHANGELOG.md
   6ae64e247 registry: Fix panic when server is unreachable
   5c619ca1b website: Remove links to the getting started guide's old location
   06275647e Update CHANGELOG.md
   d5f9411f5 command: Fix bug when using terraform login on Windows
   4b6d06cc5 Update CHANGELOG.md
   dd01a3507 Update CHANGELOG.md
   225466bc3 Cleanup after v0.12.23 release
5. provider_source.go=import (
provider_source.go:func providerSource(configs []*cliconfig.ProviderInstallation, services *disco.Disco) (getproviders.Source, tfdiags.Diagnostics) {
provider_source.go=func implicitProviderSource(services *disco.Disco) getproviders.Source {
provider_source.go:func providerSourceForCLIConfigLocation(loc cliconfig.ProviderInstallationLocation, services *disco.Disco) (getproviders.Source, tfdiags.Diagnostics) {
6. 35a058fb3 main: configure credentials from the CLI config file
   c0b176109 prevent log output during init
   8364383c3 Push plugin discovery down into command package
7. commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5
   Author: Martin Atkins <mart@degeneration.co.uk>

