function [dir_in, dir_OUT, in_files] = LID_db_info(train_or_dev,OUT)

dir_in = cell(12);
dir_OUT = cell(12);
in_files = cell(12);
%num_files = cell(12);
if strcmp(lower(train_or_dev),'train')
%English - North USA
dir_in{1} = 'C:\LID\train\English\TRAIN\';
dir_OUT{1} = ['C:\LID\train\English\',OUT,'\'];
in_files{1} = 'english1.txt';
%num_files{1} = 'No_Sa_ENGN.num';

%Arabic
dir_in{2} = 'C:\LID\train\Arabic\TRAIN\';
dir_OUT{2} = ['C:\LID\train\Arabic\',OUT,'\'];
in_files{2} = 'arabic.txt';
%num_files{2} = 'No_Sa_FR.num';

%French
dir_in{3} = 'C:\LID\train\French\TRAIN\';
dir_OUT{3} = ['C:\LID\train\French\',OUT,'\'];
in_files{3} = 'French.txt';
%num_files{3} = 'No_Sa_AR.num';

%Farisi
dir_in{4} = 'C:\LID\train\Farsi\TRAIN\';
dir_OUT{4} = ['C:\LID\train\Farsi\',OUT,'\'];
in_files{4} = 'farsi.txt';
%num_files{4} = 'No_Sa_FA.num';

%German
dir_in{5} = 'C:\LID\train\german\TRAIN\';
dir_OUT{5} = ['C:\LID\train\german\',OUT,'\'];
in_files{5} = 'german.txt';
%num_files{5} = 'No_Sa_GR.num';

%Hindi
dir_in{6} = 'C:\LID\train\Hindi\TRAIN\';
dir_OUT{6} = ['C:\LID\train\Hindi\',OUT,'\'];
in_files{6} = 'hindi.txt';
%num_files{6} = 'No_Sa_HI.num';

%Japanese
dir_in{7} = 'C:\LID\train\japanese\TRAIN\';
dir_OUT{7} = ['C:\LID\train\japanese\',OUT,'\'];
in_files{7} = 'japanese.txt';
%num_files{7} = 'No_Sa_JA.num';

%Korean
dir_in{8} = 'C:\LID\train\korean\TRAIN\';
dir_OUT{8} = ['C:\LID\train\korean\',OUT,'\'];
in_files{8} = 'korean.txt';
%num_files{8} = 'No_Sa_KO.num';

%Mandarin
dir_in{9} = 'C:\LID\train\Maindarin\TRAIN\';
dir_OUT{9} = ['C:\LID\train\Maindarin\',OUT,'\'];
in_files{9} = 'mandarin.txt';
%num_files{9} = 'No_Sa_MAM.num';

%Caribbean Spanish
dir_in{10} = 'C:\LID\train\Spanish\TRAIN\';
dir_OUT{10} = ['C:\LID\train\Spanish\',OUT,'\'];
in_files{10} = 'spanish.txt';
%num_files{10} = 'No_Sa_SPC.num';

%Tamil
dir_in{11} = 'C:\LID\train\Tamil\TRAIN\';
dir_OUT{11} = ['C:\LID\train\Tamil\',OUT,'\'];
in_files{11} = 'tamil.txt';
%num_files{11} = 'No_Sa_TA.num';

%Vietnamese
dir_in{12} = 'C:\LID\train\Vietnamese\TRAIN\';
dir_OUT{12} = ['C:\LID\train\Vietnamese\',OUT,'\'];
in_files{12} = 'vietnamese.txt';
%num_files{12} = 'No_Sa_VI.num';

else %Dev Set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%English - North USA
dir_in{1} = 'G:\CallFriend DB\CF DevSet\English-N\CF_ENG_N\Devtest\';
dir_OUT{1} = ['F:\combined\English\',OUT,'\'];
in_files{1} = 'english_all.txt';
%num_files{1} = 'No_Sa_ENGN.num';

%French
dir_in{2} = 'G:\CallFriend DB\CF DevSet\French\CF_FRE\DEVTEST\';
dir_OUT{2} = ['F:\combined\French\',OUT,'\'];
in_files{2} = 'french.txt';
%num_files{2} = 'No_Sa_FR.num';

%Arabic
dir_in{3} = 'G:\CallFriend DB\CF DevSet\Arabic\CF_ARA\DEVTEST\';
dir_OUT{3} = ['F:\combined\Arabic\',OUT,'\'];
in_files{3} = 'arabic.txt';
%num_files{3} = 'No_Sa_AR.num';

%Farisi
dir_in{4} = 'G:\CallFriend DB\CF DevSet\Farsi\CF_FAR\DEVTEST\';
dir_OUT{4} = ['F:\combined\Farsi\',OUT,'\'];
in_files{4} = 'farsi.txt';
%num_files{4} = 'No_Sa_FA.num';

%German
dir_in{5} = 'G:\CallFriend DB\CF DevSet\German\CF_GER\DEVTEST\';
dir_OUT{5} = ['F:\combined\German\',OUT,'\'];
in_files{5} = 'german.txt';
%num_files{5} = 'No_Sa_GR.num';

%Hindi
dir_in{6} = 'G:\CallFriend DB\CF DevSet\Hindi\CF_HIN\DEVTEST\';
dir_OUT{6} = ['F:\combined\Hindi\',OUT,'\'];
in_files{6} = 'hindi.txt';
%num_files{6} = 'No_Sa_HI.num';

%Japanese
dir_in{7} = 'G:\CallFriend DB\CF DevSet\Japanese\CF_JAP\DEVTEST\';
dir_OUT{7} = ['F:\combined\Japanese\',OUT,'\'];
in_files{7} = 'japanese.txt';
%num_files{7} = 'No_Sa_JA.num';

%Korean
dir_in{8} = 'G:\CallFriend DB\CF DevSet\Korean\CF_KOR\DEVTEST\';
dir_OUT{8} = ['F:\combined\Korean\',OUT,'\'];
in_files{8} = 'korean.txt';
%num_files{8} = 'No_Sa_KO.num';

%Mainland Mandarin
dir_in{9} = 'G:\CallFriend DB\CF DevSet\M_Mandarin\CF_MAN_M\DEVTEST\';
dir_OUT{9} = ['F:\combined\Mandarin\',OUT,'\'];
in_files{9} = 'mandarin_all.txt';
%num_files{9} = 'No_Sa_MAM.num';

%Caribbean Spanish
dir_in{10} = 'G:\CallFriend DB\CF DevSet\C_Spanish\CF_SPA_C\DEVTEST\';
dir_OUT{10} = ['F:\combined\Spanish\',OUT,'\'];
in_files{10} = 'spanish_all.txt';
%num_files{10} = 'No_Sa_SPC.num';

%Tamil
dir_in{11} = 'G:\CallFriend DB\CF DevSet\Tamil\CF_TAM\DEVTEST\';
dir_OUT{11} = ['F:\combined\Tamil\',OUT,'\'];
in_files{11} = 'tamil.txt';
%num_files{11} = 'No_Sa_TA.num';

%Vietnamese
dir_in{12} = 'G:\CallFriend DB\CF DevSet\Vietnamese\CF_VIE\DEVTEST\';
dir_OUT{12} = ['F:\combined\Vietnamese\',OUT,'\'];
in_files{12} = 'Vietnamese.txt';
end