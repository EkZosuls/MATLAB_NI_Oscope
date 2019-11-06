function stopDAC(src,eventdata, s,lh,FS)
  % helper function to stop and safely end a forever DAQ session
  %Aleks Zosuls Boston University 2016
    s.stop
    disp('stopping Dquack')
    delete(lh)
    clear lh
    delete(FS)
    clear FS
end