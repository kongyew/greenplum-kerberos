# Use JDBC with Kerberos to access Greenplum cluster
This example demonstrates how to access Greenplum cluster with JDBC and kerberos settings.

## Setup sample database
Run setupDB.sh to create basic_db and basictable.
```
[gpadmin@gpdbsne ~]$ setupDB.sh
psql:./sample_table.sql:1: NOTICE:  table "basictable" does not exist, skipping
DROP TABLE
psql:./sample_table.sql:5: NOTICE:  CREATE TABLE will create implicit sequence "basictable_id_seq" for serial column "basictable.id"
CREATE TABLE
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 9
INSERT 0 18
INSERT 0 36
INSERT 0 72
INSERT 0 144
INSERT 0 288
INSERT 0 576
INSERT 0 1152
INSERT 0 2304
INSERT 0 4608
```

### Run JDBC test

Change directory to ``/home/gpadmin` that has related jar files. Run the example below that access database `basic_db`
```
[gpadmin@gpdbsne ~]$java $JAVA_OPTS -classpath ./greenplum.jar:./postgresql-42.1.4.jar:./JDBCTest-1.0.jar io.pivotal.support.JDBCTest "jdbc:postgresql://localhost:5432/basic_db?kerberosServerName=gpadmin&jaasApplicationName=pgjdbc&user=gpadmin/kdc-kadmin&&loggerLevel=TRACE&loggerFile=pgjdbctrace.log" "select count(*) from basictable" com.pivotal.jdbc.GreenplumDriver

```

## Debug messages :

This message shows commit is successful
```
Num of args=3
ARG0: jdbc:postgresql://localhost:5432/basic_db?kerberosServerName=gpadmin&jaasApplicationName=pgjdbc&user=gpadmin/kdc-kadmin&&loggerLevel=TRACE&loggerFile=pgjdbctrace.log
ARG1: select count(*) from basictable
ARG2: com.pivotal.jdbc.GreenplumDriver
user=
pass=
Debug is  true storeKey false useTicketCache true useKeyTab true doNotPrompt true ticketCache is null isInitiator true KeyTab is null refreshKrb5Config is false principal is null tryFirstPass is false useFirstPass is false storePass is false clearPass is false
Acquire TGT from Cache
>>>KinitOptions cache name is /tmp/krb5cc_500
>>>DEBUG <CCacheInputStream>  client principal is gpadmin/kdc-kadmin@EXAMPLE.COM
>>>DEBUG <CCacheInputStream> server principal is krbtgt/EXAMPLE.COM@EXAMPLE.COM
>>>DEBUG <CCacheInputStream> key type: 18
>>>DEBUG <CCacheInputStream> auth time: Sun Nov 05 21:01:10 UTC 2017
>>>DEBUG <CCacheInputStream> start time: Sun Nov 05 21:01:10 UTC 2017
>>>DEBUG <CCacheInputStream> end time: Mon Nov 06 21:01:10 UTC 2017
>>>DEBUG <CCacheInputStream> renew_till time: null
>>> CCacheInputStream: readFlags()  INITIAL; PRE_AUTH;
>>>DEBUG <CCacheInputStream>  client principal is gpadmin/kdc-kadmin@EXAMPLE.COM
Java config name: null
Native config name: /etc/krb5.conf
Loaded from native config
>>>DEBUG <CCacheInputStream> server principal is X-CACHECONF:/krb5_ccache_conf_data/fast_avail/krbtgt/EXAMPLE.COM@EXAMPLE.COM@EXAMPLE.COM
>>>DEBUG <CCacheInputStream> key type: 0
>>>DEBUG <CCacheInputStream> auth time: Thu Jan 01 00:00:00 UTC 1970
>>>DEBUG <CCacheInputStream> start time: null
>>>DEBUG <CCacheInputStream> end time: Thu Jan 01 00:00:00 UTC 1970
>>>DEBUG <CCacheInputStream> renew_till time: null
>>> CCacheInputStream: readFlags()
>>>DEBUG <CCacheInputStream>  client principal is gpadmin/kdc-kadmin@EXAMPLE.COM
>>>DEBUG <CCacheInputStream> server principal is null
>>>DEBUG <CCacheInputStream> key type: 18
>>>DEBUG <CCacheInputStream> auth time: Sun Nov 05 21:01:10 UTC 2017
>>>DEBUG <CCacheInputStream> start time: Sun Nov 05 21:03:26 UTC 2017
>>>DEBUG <CCacheInputStream> end time: Mon Nov 06 21:01:10 UTC 2017
>>>DEBUG <CCacheInputStream> renew_till time: null
>>> CCacheInputStream: readFlags()  PRE_AUTH;
>>>DEBUG <CCacheInputStream>  client principal is gpadmin/kdc-kadmin@EXAMPLE.COM
>>>DEBUG <CCacheInputStream> server principal is postgres/gpdbsne.example.com@EXAMPLE.COM
>>>DEBUG <CCacheInputStream> key type: 18
>>>DEBUG <CCacheInputStream> auth time: Sun Nov 05 21:01:10 UTC 2017
>>>DEBUG <CCacheInputStream> start time: Sun Nov 05 21:03:26 UTC 2017
>>>DEBUG <CCacheInputStream> end time: Mon Nov 06 21:01:10 UTC 2017
>>>DEBUG <CCacheInputStream> renew_till time: null
>>> CCacheInputStream: readFlags()  PRE_AUTH;
Principal is gpadmin/kdc-kadmin@EXAMPLE.COM
Commit Succeeded

Found ticket for gpadmin/kdc-kadmin@EXAMPLE.COM to go to krbtgt/EXAMPLE.COM@EXAMPLE.COM expiring on Mon Nov 06 21:01:10 UTC 2017
Entered Krb5Context.initSecContext with state=STATE_NEW
Found ticket for gpadmin/kdc-kadmin@EXAMPLE.COM to go to krbtgt/EXAMPLE.COM@EXAMPLE.COM expiring on Mon Nov 06 21:01:10 UTC 2017
Service ticket not found in the subject
>>> Credentials acquireServiceCreds: same realm
Using builtin default etypes for default_tgs_enctypes
default etypes for default_tgs_enctypes: 18 17 16 23.
>>> CksumType: sun.security.krb5.internal.crypto.RsaMd5CksumType
>>> EType: sun.security.krb5.internal.crypto.Aes256CtsHmacSha1EType
>>> KdcAccessibility: reset
>>> KrbKdcReq send: kdc=kdc-kadmin.example.com UDP:88, timeout=30000, number of retries =3, #bytes=671
>>> KDCCommunication: kdc=kdc-kadmin.example.com UDP:88, timeout=30000,Attempt =1, #bytes=671
>>> KrbKdcReq send: #bytes read=674
>>> KdcAccessibility: remove kdc-kadmin.example.com
>>> EType: sun.security.krb5.internal.crypto.Aes256CtsHmacSha1EType
>>> KrbApReq: APOptions are 00100000 00000000 00000000 00000000
>>> EType: sun.security.krb5.internal.crypto.Aes256CtsHmacSha1EType
Krb5Context setting mySeqNumber to: 669057102
Created InitSecContextToken:
0000: 01 00 6E 82 02 5D 30 82   02 59 A0 03 02 01 05 A1  ..n..]0..Y......
0010: 03 02 01 0E A2 07 03 05   00 20 00 00 00 A3 82 01  ......... ......
0020: 63 61 82 01 5F 30 82 01   5B A0 03 02 01 05 A1 0D  ca.._0..[.......
0030: 1B 0B 45 58 41 4D 50 4C   45 2E 43 4F 4D A2 1F 30  ..EXAMPLE.COM..0
0040: 1D A0 03 02 01 00 A1 16   30 14 1B 07 67 70 61 64  ........0...gpad
0050: 6D 69 6E 1B 09 6C 6F 63   61 6C 68 6F 73 74 A3 82  min..localhost..
0060: 01 22 30 82 01 1E A0 03   02 01 12 A1 03 02 01 02  ."0.............
0070: A2 82 01 10 04 82 01 0C   58 E3 74 A3 C5 24 A2 90  ........X.t..$..
0080: 80 EB 7F F1 ED F8 01 AC   0F 34 B2 4B CD 4B EA 1D  .........4.K.K..
0090: D8 9E 57 75 EE 7D 6D 96   B3 04 33 DA F7 8E 36 14  ..Wu..m...3...6.
00A0: 26 41 E1 F3 CC F3 4A 92   5E B0 99 1F DE A6 03 17  &A....J.^.......
00B0: 56 89 7A 93 05 21 57 A3   0B 69 CA C6 6B 87 1E CA  V.z..!W..i..k...
00C0: A4 9E 34 B5 E6 D7 DB EF   1A 83 23 6F 8B 1C 59 C5  ..4.......#o..Y.
00D0: 2E 5D 0C F2 C6 7F 3E C2   2F F4 BD CC 2A 05 66 DC  .]....>./...*.f.
00E0: FD 20 3B 52 8A D3 86 7D   0A C4 5E DC 70 86 4E 15  . ;R......^.p.N.
00F0: 95 4C 82 9F FC F0 4E C8   F5 72 24 45 CF C6 4F 19  .L....N..r$E..O.
0100: CF 46 94 52 2A 1D 60 AE   FA BD 76 74 90 41 94 02  .F.R*.`...vt.A..
0110: B5 F6 D9 2C E6 85 B2 73   D9 5F 4A 67 54 8C BD 0C  ...,...s._JgT...
0120: 3C FE 5B DE FC EB 21 BE   50 BA 48 B2 33 EC B1 87  <.[...!.P.H.3...
0130: BA B3 61 AD D6 41 28 AE   2C 4B F1 CD 2C 22 54 03  ..a..A(.,K..,"T.
0140: 01 AE 9E 0C 2F BE 9C B6   05 EC 15 01 8A 7B A2 1A  ..../...........
0150: D3 BE 5C A2 82 65 17 F3   B0 6F 89 25 CA EA 33 FC  ..\..e...o.%..3.
0160: 3D BB D2 ED 12 2F B6 D1   D4 34 44 E4 AB 72 F2 29  =..../...4D..r.)
0170: 4D F9 7D DE F7 6E C1 90   39 32 1D B6 43 3F 04 EE  M....n..92..C?..
0180: 1A D2 BB 55 A4 81 DC 30   81 D9 A0 03 02 01 12 A2  ...U...0........
0190: 81 D1 04 81 CE A3 6A F2   E4 24 A2 07 3C 04 07 5A  ......j..$..<..Z
01A0: 24 05 C9 B0 34 18 35 C4   F3 EC FF 7B 4F 10 E3 45  $...4.5.....O..E
01B0: 2A 32 29 18 05 FD 0A E8   26 F2 A7 71 35 80 6E 07  *2).....&..q5.n.
01C0: B7 0F 94 C1 FB CD 50 93   A1 39 47 E6 2E 73 F2 EC  ......P..9G..s..
01D0: 07 4F AA D7 9F 82 F2 4D   BC 24 F2 DB 93 C1 2D 06  .O.....M.$....-.
01E0: D0 33 25 6B C9 5A 11 94   D4 70 40 2E 8E F8 49 85  .3%k.Z...p@...I.
01F0: B0 6B 2D 67 08 F0 7A B9   20 4E 2F 89 83 F5 E9 E4  .k-g..z. N/.....
0200: 6C 72 E1 A8 49 FA 41 AF   29 0C C5 B2 0D 18 75 77  lr..I.A.).....uw
0210: A2 B2 1A F3 81 FE ED 77   28 64 C1 4A BC 40 F6 B2  .......w(d.J.@..
0220: C1 1D 73 04 3D 18 C0 9E   2B 51 95 F5 98 7C 83 EA  ..s.=...+Q......
0230: FE F0 BF 66 3E 40 84 62   B5 4A 75 E6 7C 00 9F 75  ...f>@.b.Ju....u
0240: E7 2F 42 A1 96 7A B7 6D   29 55 A7 61 75 D2 46 33  ./B..z.m)U.au.F3
0250: 95 70 EC F7 7C 58 3E 13   7C 01 9E 02 0B 8F 0A 25  .p...X>........%
0260: 38 A8 43                                           8.C

Entered Krb5Context.initSecContext with state=STATE_IN_PROCESS
>>> EType: sun.security.krb5.internal.crypto.Aes256CtsHmacSha1EType
Krb5Context setting peerSeqNumber to: 328584656
Attempt to execute: 0
Attempt to execute: 1
```
