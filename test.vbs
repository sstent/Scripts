i=2
Wscript.echo "working"
ZipAge = ((Weekday(Date, vbSaturday))-1)
Wscript.echo "zipage " & ZipAge
if ZipAge = 0 then ZipAge = ((i-2) * 7) else ZipAge = ZipAge + 7 + ((i-2) * 7)
Wscript.echo "modzipage " & ZipAge
nDate = DateAdd("d", (0-(ZipAge+6)), now())
Wscript.echo "ndate " & nDate