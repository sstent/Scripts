
REM EXPECTS newhosts to contain <hostname><tab><ip.add.re.ss>
for /f "tokens=1,2,3,4,5,6 delims=	." %%1 in (newhosts.txt) do (
dnscmd 10.0.79.11 /RecordAdd barnesandnoble.com %%1 A %%2.%%3.%%4.%%5
dnscmd 10.0.79.11  /recordadd %%2.in-addr.arpa. %%5.%%4.%%3 PTR %%1.barnesandnoble.com.
)