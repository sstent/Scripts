
REM COMMWEB1
robocopy \\pnycommweb01\d$\InetPub\Community\quicksearch\bin \\pnycommweb01\d$\rollback\20110201\community bn.webutils.dll.config /log+:roll1.log
robocopy \\pnycommweb01\d$\InetPub\Wizard\quicksearch\bin \\pnycommweb01\d$\rollback\20110201\wizard bn.webutils.dll.config /log+:roll1.log


REM STRLOCWEB
robocopy \\pnystrlocweb01\d$\InetPub\Kids\quicksearch\bin \\pnystrlocweb01\d$\rollback\20110201\kids bn.webutils.dll.config /log+:roll1.log
robocopy \\pnystrlocweb01\d$\InetPub\StoreLocator\quicksearch\bin \\pnystrlocweb01\d$\rollback\20110201\storelocator bn.webutils.dll.config /log+:roll1.log

REM NETCART

robocopy \\pnynetcart01\d$\InetPub\Cart\quicksearch\bin \\pnynetcart01\d$\rollback\20110201\cart bn.webutils.dll.config /log+:roll1.log

REM SRCHRES
robocopy  \\pnysrchres01\d$\InetPub\SEARCHRES\quicksearch\bin \\pnysrchres01\d$\rollback\20110201\searchres bn.webutils.dll.config /log+:roll1.log
REM MVP

robocopy  \\pnymvp01\d$\InetPub\Gifts\QuickSearch\bin \\pnymvp01\d$\rollback\20110201\gifts bn.webutils.dll.config /log+:roll1.log
