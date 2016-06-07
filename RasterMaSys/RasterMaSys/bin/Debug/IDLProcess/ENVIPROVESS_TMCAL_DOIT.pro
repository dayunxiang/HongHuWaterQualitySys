;������ֻ���landsat7Ӱ��Ķ���׺ͺ��Ⲩ�ν��з��䶨�꣬��������������Ӱ����д���
;����Ĳ���ΪLandsat��׼ͷ�ļ�.MTL.txt�ļ����Լ����������ļ���
PRO ENVIPROVESS_TMCAL_DOIT,inputFile,outputFolder,mb_output=mb_output,thre_output=thre_output
  COMPILE_OPT IDL2
  ; First restore all the base save files.
  ENVI, /RESTORE_BASE_SAVE_FILES
  ;��ʼ��ENVI
  ENVI_BATCH_INIT, LOG_FILE='batch.txt'
  ;�����ļ�
  ;inputFile='E:\LE71220392012211EDC00\LE71220392012211EDC00_MTL.txt'
  ;outputFolder='E:\LE71220392012211EDC00\tmp'
  ;��׽����
  catch,error_status
  errorShow='���䶨�괦������з����˴���'
  if Error_status ne 0 then begin
    tmp=dialog_message(errorShow+string(13b)+$
      !error_state.msg,/error,title='������ʾ!')
    
    return
  endif
  ; ������
  ENVI_OPEN_DATA_FILE, inputFile, /LANDSAT_METADATA
  ;��ȡFIDS
  fids = ENVI_GET_FILE_IDS()
  
  ;�ж�ͷ�ļ��Ƿ����
  IF (fids[0] EQ -1) THEN BEGIN
    messageDialog=dialog_message('ѡ���landsatͷ�ļ���ʽ����!',/error)
    ENVI_BATCH_EXIT
    RETURN
  ENDIF
  
  ; ���Ҷ���ײ���
  FOR j = 0, N_ELEMENTS(fids) -1 DO BEGIN
    ENVI_FILE_QUERY, fids[j], NB = nb
    ;��ȡ6������ײ��ε�fid
    IF (nb EQ 6) THEN mb_fid = fids[j]
    ;��ȡ����
    if (nb EQ 2)then ther_fid=fids[j]
  ENDFOR
  
  ;����׷��䶨��,����Ϊ������
  if mb_fid eq -1 then begin
    messageDialog=dialog_message('�޷���ȡѡ��Ӱ��Ķ���ײ���!',/error)
  endif else begin
    mb_output=My_caliration(mb_fid,0,outputFolder)
  endelse
  
  ;������䶨�꣬����Ϊ������
  if ther_fid eq -1 then begin
    messageDialog=dialog_message('�޷���ȡѡ��Ӱ��ĺ��Ⲩ��!',/error)
  endif else begin
    thre_output=My_caliration(ther_fid,0,outputFolder)
  endelse
  ;�˳�envi
  ;ENVI_BATCH_EXIT
END


function My_caliration,fid,cal_type,outputFolder
  ENVI_FILE_QUERY, fid, DIMS =dims, $
    NB = nb, SNAME = sname
  POS = LINDGEN(nb)
  
  ;���ݶ�����Ƕ���׻��Ǻ���ȷ���������
  if nb eq 2 then begin
    out_name=outputFolder+'\' +file_basename(sname,'_mtl.txt')+ '_Ther_radi.tif'
  endif
  if nb eq 6 then begin
    out_name=outputFolder+'\' +file_basename(sname,'_mtl.txt')+ '_Mul_radi.tif'
  endif
  
  ; ���з��䶨��
  ENVI_DOIT, 'TMCAL_DOIT', $
    FID = fid, POS = pos, DIMS = dims, $
    CAL_TYPE = cal_type, OUT_NAME = out_name, $
    R_FID = r_fid, /USE_METADATA
    
  return,out_name
end

