selinux Cookbook CHANGELOG
==========================

## 1.0.3 (2017-03-14)

- Fix requirement in metadata to reflect need for Chef 12.7 as using action_class in state resource.

## 1.0.2 (2017-03-01)

- Remove setools* packages from install resource (utility to analyze and query policies, monitor and report audit logs, and manage file context). Future versions of this cookbook that might use this need to handle package install on Oracle Linux as not available in default repo.

## 1.0.1 (2017-02-26)

- Fix logic error in the permissive state change

## 1.0.0 (2017-02-26)

- Update to current cookbook engineering standards
- Removed property `state` of resource `selinux_state` as `state` overwrites an existing method. Chef 13 exception fix.
- Rewrite LWRP to 12.5 resources
- Resolved cookstyle errors
- Update package information for debian based on https://debian-handbook.info/browse/stable/sect.selinux.html
 - selinux-activate looks like it's required to ACTUALLY activate selinux on non-RHEL systems. This seems like it could be destructive if unexpected.
- Add property temporary to allow for switching between permissive and enabled
- Add install resource

v0.9.0 (2015-02-22)
-------------------
- Initial Debian / Ubuntu support
- Various bug fixes

v0.8.0 (2014-04-23)
-------------------
- [COOK-4528] - Fix selinux directory permissions
- [COOK-4562] - Basic support for Ubuntu/Debian


v0.7.2 (2014-03-24)
-------------------
handling minimal installs


v0.7.0 (2014-02-27)
-------------------
[COOK-4218] Support setting SELinux boolean values


v0.6.2
------
- Fixing bug introduced in 0.6.0 
- adding basic test-kitchen coverage


v0.6.0
------
- [COOK-760] - selinux enforce/permit/disable based on attribute


v0.5.6
------
- [COOK-2124] - enforcing recipe fails if selinux is disabled

v0.5.4
------
- [COOK-1277] - disabled recipe fails on systems w/o selinux installed

v0.5.2
------
- [COOK-789] - fix dangling commas causing syntax error on some rubies

v0.5.0
------
- [COOK-678] - add the selinux cookbook to the repository
- Use main selinux config file (/etc/selinux/config)
- Use getenforce instead of selinuxenabled for enforcing and permissive
