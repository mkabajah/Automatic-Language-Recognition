function SVM = read_SVM(dir,filename, type)
if nargin < 3 || isempty(type)
    type = 'double';
end

fp = fopen([dir,filename],'r');
nd = fread(fp,2,'int');
if isequal(type ,'single')
  SVM.xsup = single(fread(fp,[nd(1),nd(2)],'float'));
  nd = fread(fp,2,'int');
  SVM.w = single(fread(fp,[nd(1),nd(2)],'float'));
else
  SVM.xsup = fread(fp,[nd(1),nd(2)],'float');
  nd = fread(fp,2,'int');
  SVM.w = fread(fp,[nd(1),nd(2)],'float');  
end

SVM.b = fread(fp,'float');
fclose(fp);

SVM.xsup = SVM.xsup';