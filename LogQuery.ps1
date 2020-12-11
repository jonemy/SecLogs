# Nothing special here, will backup security log then query it for various events and write the outpot to disk. There is no logic to the events here, they are strictly placeholders.
# Uncomment the next 3 line to backup and clear the security log.
# $EventLog = Get-WmiObject Win32_NTEventlogFile -Filter "LogFileName = 'Security'"
# $eventlog.BackupEventlog("c:\temp\securitylog$(get-date -f ddMMMyyyy).evtx")
# Clear-EventLog -LogName Security

echo "Collecting 4648 and 4624" >> "C:\temp\AuditResults$(get-date -f ddMMMyyyy).txt"

$query = @"
<QueryList>
  <Query Id="0" Path="file://C:\temp\securitylog$(get-date -f ddMMMyyyy).evtx">
    <Select>*[System[(EventID=4648 or EventID=4624)]]</Select>
  </Query>
</QueryList>
"@

# First line gives a total count, 2nd line tallies each eventID
@(get-winevent -FilterXml $Query).count >> "C:\temp\AuditResults$(get-date -f ddMMMyyyy).txt"
@(get-winevent -FIlterXml $Query) | group id -noelement | sort count -d >> "C:\temp\AuditResults$(get-date -f ddMMMyyyy).txt"
 
# `r`r adds linefeeds to the output
echo `r`r "Collecting 4719 and 1100" >> "C:\temp\AuditResults$(get-date -f ddMMMyyyy).txt"

$query = @"
<QueryList>
  <Query Id="0" Path="file://C:\temp\securitylog$(get-date -f ddMMMyyyy).evtx">
    <Select>*[System[(EventID=4719 or EventID=1100)]]</Select>
  </Query>
</QueryList>
"@


@(get-winevent  -FilterXml $Query).count >> "C:\temp\AuditResults$(get-date -f ddMMMyyyy).txt"
@(get-winevent -FIlterXml $Query) | group id -noelement | sort count -d >> "C:\temp\AuditResults$(get-date -f ddMMMyyyy).txt"


echo `r`r "Collecting 4688" >> "C:\temp\AuditResults$(get-date -f ddMMMyyyy).txt"

$query = @"
<QueryList>
  <Query Id="0" Path="file://C:\temp\securitylog$(get-date -f ddMMMyyyy).evtx">
    <Select>*[System[(EventID=4688)]]</Select>
  </Query>
</QueryList>
"@

@(get-winevent  -FilterXml $Query).count >> "C:\temp\AuditResults$(get-date -f ddMMMyyyy).txt"
@(get-winevent -FIlterXml $Query) | group id -noelement | sort count -d >> "C:\temp\AuditResults$(get-date -f ddMMMyyyy).txt"


echo "Finished for $(get-date -f ddMMMyyyy)" >> "C:\temp\AuditResults$(get-date -f ddMMMyyyy).txt"
