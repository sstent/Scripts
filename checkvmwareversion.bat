for %%i in (pnjasyncvhost02,pnjjettyvhost02,pnjjettyvhost03,pnjnookdev01,pnjjettyvhost04,pnjjettyvhost06,pnjjettyvhost05,pnjintjetty01,pnjasyncvhost01,pnjjettyvhost01,injsoavhost01,injsoavhost02,injsoavhost03,injsoavhost04,injperfvhost01,injpejettyvhost03,injpejettyvhost01,injpejettyvhost02,injpeasyncvhost01,injpeintjetty01,injpesoavhost01,injpesoavhost02,injpesoavhost03,injpesoavhost04,pnjsoavhost01,pnjsoavhost02,pnjsoavhost03,pnjsoavhost04,pwbsoavhost03,pwbsoavhost01,pwbsoavhost02,pwbsoavhost04,pnyvhost01,pnyvhost02,pnyvhost03,pnyvhost04,pnyvhost06,pnyvhost05,pwbasyncvhost02,pwbjettyvhost01,pwbjettyvhost02,pwbnookdev01,pwbjettyvhost03,pwbjettyvhost04,pwbjettyvhost05,pwbasyncvhost01,pwbintjetty01,pwbjettyvhost06,pwbvhost02,pwbvhost03,pwbvhost04,pwbvhost05,pwbvhost01,bwbvhost02,bwbvhost01,bwbvhost03,pwbtestvhost01,pwbtestvhost02,pwbtestvhost03) do (
echo %%i >> vmwarehosts.txt
plink -l root -pw 351iq814 %%i vmware -v >> vmwarehosts.txt
plink -l root -pw s716X1aF %%i vmware -v >> vmwarehosts.txt
)

