;ʹ�õĿ��ٴ���У����
PRO CAL_QUC,inputfile,outputfile
  COMPILE_OPT IDL2
  ; First restore all the base save files.
  ENVI, /RESTORE_BASE_SAVE_FILES
  ;��ʼ��ENVI
  ENVI_BATCH_INIT, LOG_FILE='CAL_QUC_batch.txt'
  ;����׽
  catch,error_status
  errorShow='����У����������з����˴���'
  if Error_status ne 0 then begin
    tmp=dialog_message(errorShow+string(13b)+$
      !error_state.msg,/error,title='������ʾ')
    return
  endif
  ;���ļ�
  ENVI_OPEN_FILE, inputfile, r_fid=fid
  IF (fid EQ -1) THEN BEGIN
    tmp=dialog_message(inputfile+string(13b)+'��ʧ��',/info)
    RETURN
  ENDIF
  ;��ȡ�ļ���Ϣ
  ENVI_FILE_QUERY, fid, dims=dims, nb=nb, sensor_type=sensor_type
  if nb lt 3 then begin
    tmp=dialog_message('����У����Ӱ��������Ҫ����������!',/error,title='������ʾ')
    return
  endif
  pos  = LINDGEN(nb)
  
  sensor = envi_sensor_type(sensor_type)
  ;���ô���У������
  ENVI_DOIT, 'envi_quac_doit', $
    fid=fid, pos=pos, dims=dims, $
    quac_sensor=sensor, $
    out_name=outputfile, r_fid=r_fid
  ;ENVI_BATCH_EXIT
End