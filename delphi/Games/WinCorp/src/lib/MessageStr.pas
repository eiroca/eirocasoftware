(* GPL > 3.0
Copyright (C) 1997-2008 eIrOcA Enrico Croce & Simona Burzio

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*)
(*
 @author(Enrico Croce)
*)
unit MessageStr;

interface

resourcestring
  IDS_OK       = 'Ok';
  IDS_PLAY     = '&Play';
  IDS_EXIT     = '&Exit';
  IDS_HELP     = '&Instructions';

  IDS_STABLE   = 'stable';
  IDS_GODOWN   = 'down by %g %%';
  IDS_GOUP     = 'up by %g %%';

  IDS_OPER1    = 'Entering quarter %d your workforce is %d.';
  IDS_OPER2    = '%d employees joined the company.';
  IDS_OPER3    = '%d employees left the company.';
  IDS_OPER4    = 'You manufactured %d (000) Widgets.';
  IDS_OPER5    = 'Standard unit cost was $%6.2f per unit.';
  IDS_OPER6    = 'Current inventory is: %d (000) units.';

  IDS_COMP1    = 'You sold %d (000) units at $%6.2f per unit';
  IDS_COMP2    = 'Workforce went %s';
  IDS_COMP3    = 'Inventory went %s';
  IDS_COMP4    = 'Product sales went %s';
  IDS_COMP5    = 'Unit cost went %s';
  IDS_COMP6    = 'Salary cost went %s';

  IDS_FHELP    = 'Instructions';

  IDS_CAPOPER  = ' [[ OPERATING PERFORMANCE ]] ';
  IDS_CAPCOMP  = ' [[ COMPARATIVE RESULTS ]] ';
  IDS_CAPFLHRP = ' [[  JOB && ECONOMY REPORT ]] ';
  IDS_FRESULT  = 'Quarter results';

  IDS_LBMAIN2  = 'A business simulation game';

  IDS_CAPMARPT = 'Market Report';
  IDS_LBMRTIT  = 'Super Trash Market Analisis';
  IDS_LBQTR    = 'Market Analisis of Quarter: %d';
  IDS_GBPRINDX = 'Price Index';
  IDS_GBADINDX = 'Advertising Index';
  IDS_GBRDINDX = 'R && D Index';
  IDS_LBPRICE  = 'Price';
  IDS_LBQTY    = 'Quantity';
  IDS_LBCST    = 'Cost';
  IDS_LBCHANGE = 'Change';
  IDS_MARREPOK = 'Thank you';
  IDS_GBPAMIX  = 'Price/Adver. Mix';
  IDS_LBMIX1   = 'P';
  IDS_LBMIX2   = 'A';

  IDS_LBHQTR   = 'Qrt';
  IDS_LBHEMP   = 'Emplee';
  IDS_LBHINV   = 'Inventory';
  IDS_LBHCAS   = '$ In Cash';
  IDS_LBHCST   = '$ a Unit';
  IDS_LBHPRD   = 'Productivity';
  IDS_LBHINF   = 'Inflation';
  IDS_LBHSAL   = 'Salary $';
  IDS_LBHPRO   = 'Profit $';
  IDS_GBOPPE   = ' [[ OPERATING PERFORMANCE ]] ';
  IDS_GBDECI   = ' [[ DECISION ]] ';
  IDS_GBOPRE   = ' [[ OPERATING RESULT ]] ';
  IDS_NOERROR  = 'No Error';
  IDS_ERROR1   = 'You don''t have enough emoloyees to produce %d units.';
  IDS_ERROR2   = 'You don''t have enough cash to pay for these decisions.';
  IDS_ENDTERM  = 'Your Term is completed.';
  IDS_BTEXEC   = 'Execute budget';
  IDS_BTMARREP = 'Market Report';
  IDS_LBMARREP = 'Market Report:';
  IDS_LBPRI    = 'Price';
  IDS_LBPRO    = 'Production (K)';
  IDS_LBPAY    = 'Payroll';
  IDS_LBADV    = 'Advertising';
  IDS_LBRES    = 'Res. && Dev.';
  IDS_LBRREV   = '+ Revenue';
  IDS_LBRCST   = '- Manufactorig Cost';
  IDS_LBRPAY   = '- PayRoll Ammount';
  IDS_LBRADV   = '- Advertising Cost';
  IDS_LBRRES   = '- Research Cost';
  IDS_LBRPRO   = '* Net Profit';
  IDS_LBRCAS   = '* Available Cash';
  IDS_CAPGAME  = 'Operative screen';

  IDS_MESSAGE  = 'Important message';
  IDS_ENDTERM2 = 'END OF TERM';

  IDS_CAPLET   = 'Final letter';
  IDS_LBLETTIT = 'WinCorp. Directors Final Letter';
  IDS_LBSIGN   = 'The Directors                  ';
  IDS_LETMGN1  = 'Your profit margin management is outstanding! Keep it up!';
  IDS_LETMGN2  = 'Your profit margin management is very good. Good expenses control!.';
  IDS_LETMGN3  = 'Your profit margin management could be better. Analyze your decisions better.';
  IDS_LETMGN4  = 'Your profit margin management is miserable. You can do better!';
  IDS_LETTRN1  = 'Your people management is excellent. Keep it moving!';
  IDS_LETTRN2  = 'Your people management is acceptable. Watch your payroll carefully!';
  IDS_LETTRN3  = 'Your people management is marginal. Pay attention to your people!';
  IDS_LETTRN4  = 'Your people management is very poor. You need more organization stability.';
  IDS_LETASS1  = 'Your asset management is brilliant. We''re delighted with the investment!';
  IDS_LETASS2  = 'Your asset management is acceptable... but watch your cash.';
  IDS_LETASS3  = 'Your asset management is marginal. We''re frankly concerned.';
  IDS_LETASS4  = 'Your asset management is unacceptable. Our investment is disappointins.';
  IDS_LETBNKRP = 'With these results, you''ve taken the company into bankruptcy!';
  IDS_SCORE1   = 'You''ve done an excellent job in running WinCorp. We''d like to hire you for another term with a bonus of $%d000!';
  IDS_SCORE2   = 'You''ve done an adequate job with the company. We''re willing to renew your contract for another term, but we suggest that you pay more attention to the market reports.';
  IDS_SCORE3   = 'You''ve really done a pitiful job with the assets and resources of the company. We won''t be asking you to renew your contract.';
  IDS_LETTER01 = 'Mr/MS President!';
  IDS_LETTER02 = 'Over your %d quarters in office, you produced the following results:';
  IDS_LETTER03 = 'Average Revenue: %d$';
  IDS_LETTER04 = 'Average Profit: %d$';
  IDS_LETTER05 = 'Average Turnover: %d%%';
  IDS_LETTER06 = 'Average Profit Margin: %d%%';
  IDS_LETTER07 = 'Average Asset Return: %d%%';
  IDS_BTOKGOOD = 'Thank you for job';
  IDS_BTOKBAD  = 'Go away! ... and close the door when you exit!!!!';

  IDS_WFLFIRE  = 'FIRE in the plant. The production is cut by 50%% while repairs are made. The cost to restore your production is: %g';
  IDS_WFLTRAN  = 'Transportation shutdown! %g%% of sales cannot be shipped. Your customers cancel orders!';
  IDS_WFLMAJR1 = 'Major government order! Entire inventory sells out at $%g';
  IDS_WFLCSTDW = 'Outstanding parts buy! Manufacturing cost drops by $1.00!';
  IDS_WFLPRDUP = 'New Benefits Plan is introduced. Cost per employee goes up by 25%% but productivity rises by 1(000) units per person.';
  IDS_WFLCSTUP = 'Quality defects require rework with added cost of $%7.2f per unit.';
  IDS_WFLEMPUP = 'Layoff in neighboring plant. %g more employees are hired and ready to produce next quarter.';
  IDS_WFLEMPDW = 'Competitor raids your company and %g employees resign.';
  IDS_WFLSLLUP = 'Widgets wins advertising award! Market demand rises by %g%%.';
  IDS_WFLMAJR2 = 'Major order received! Total inventory can be sold at $29.95 next period with no advertising expense.';
  IDS_WFLNONE  = 'Industry is stable for the current period.';
  IDS_WMSTRIKE = 'STRIKE! Excess profits of $%d cause employee and supplier complaints. Employee costs rise by $1.00 per unit and profits are reduced by 50%%';
  IDS_WMNOCASH = 'OUT OF CASH! You must sell %d%% of production capacity to replenish cash.';
  IDS_WMNOEMP  = 'You''ve lost all your people. You must spend 50%% of your cash balance of $%d to hire new people at 30%% premium.';
  IDS_WMBANKRP = 'You''ve gone into negative cash for the last time. You''re bankrupt!';

implementation

end.

