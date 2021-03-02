%% Testar a rede neuronal
clc
clear
load('Rede_2.mat')
leaves3=[currentFolder '\Folhas_3']
cd(leaves3)


imgSet03= imageSet(leaves3)

for i=1:imgSet03.Count % obter ids de cada sample
    
    [~,id,~] = fileparts(char(imgSet03.ImageLocation(i)))
    ids_tst3(i)=str2num(id)
    im=imread([id '.jpg'])
    if isempty (find(ids_sample==ids_tst3(i)))~=1
        
    T3(i)=ids_cat(find(ids_sample==ids_tst3(i))) % categoria certa, vai ser usado para confirmar resultado da rede neuronal
    else
        T3(i)=0
    end
    featureInput3(:,i)=encode(features,im)'
    
    clear im
    clear id
end
% 
% 
% testY = net(testX);
