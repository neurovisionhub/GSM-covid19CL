t = datetime;
%t.Format = 'MMM-dd-yyyy_HH.mm.ss.SS';
t.Format = 'yyyymmddHHMMSS';
text_log = datestr(t,t.Format);

sLogParams = strcat('paramas_main_all_blocks_1-',region,'-NT_',string(numThetas),'-date_',text_log)
save_log(sLogParams,p0)

sLogErrors = strcat('error_main_all_blocks_1-',region,'-NT_',string(numThetas),'-date_',text_log)
save_log(sLogErrors,r)
compute_curves

sLogCurves = strcat('curves_main_all_blocks_1-',region,'-NT_',string(numThetas),'-date_',text_log)
save_log(sLogCurves,salida)
pUltimo=p0;