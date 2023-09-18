FROM vmware/powerclicore

RUN pwsh -c 'Set-PowerCliConfiguration -InvalidCertificateAction Ignore -ParticipateInCeip $false -Confirm:$false'

COPY move-vms.ps1 /tmp/script.ps1

ENTRYPOINT ["pwsh"]
