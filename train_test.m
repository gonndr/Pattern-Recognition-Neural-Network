clear
clc
%%

currentFolder = pwd % obter localiza��o da pasta de trabalho
leaves1=[currentFolder '\Folhas_1']

%% Bag of Features
% um bag of features � um conjunto de 'palavras visuais', caracter�sticas
% que cada imagem tem que podem ser reconhecidas pelo matlab. Estas
% palavras visuais, que s�o obtidas por um processo de clustering atrav�s
% da an�lise das imagens de input na primeira pasta, servir�o para a rede
% neuronal treinar e classificar as diferentes imagens das v�rias folhas 
imgSet0 = imageSet(leaves1)

% cria o bag of features, com um vocabul�rio de 100 palavras visuais

for i=1:imgSet0.Count
    imgSet1(i) = imageSet(imgSet0.ImageLocation(i))
end

features=bagOfFeatures(imgSet1, 'VocabularySize' ,300) 

% faz o load (vocabul�rio j� est� criado neste caso)
% load('bag.mat')

%% Categorias
% importa��o do excel que contem a classifica��o de todas as folhas
[ids_sample cat_sample]=xlsread('ClassFolh.xlsx',1,'a2:b991')

% atribui um n�mero a cada categoria (de 99)
[cat_unique,ia,ic] = unique(cat_sample)
ids_unique=1:99
ids_unique=ids_unique'
ids_cat=ids_unique(ic) % vetor que relaciona cada sample a cada numero de categoria

%% Inputs e Targets
% atrav�s da pasta Folhas_1, criar-se-� um feature vector que descrever�
% quais as palavras (das 100 do bag of features) mais presentes em cada
% folha, para todas as folhas.
cd(leaves1)
T=[] % iniciar a matriz de targets
for i=1:imgSet0.Count % ciclo que vai criar as matrizes de input e targets, a treinar pela rede neuronal
   
    [~,id,~] = fileparts(char(imgSet0.ImageLocation(i)))
    ids_tst1(i)=str2num(id)
    im=imread([id '.jpg'])
    % a matriz de targets � uma matriz com 1 nas posi��es das folhas em
    % quest�o e zeros e todas as outras
    T(ids_cat(find(ids_sample==ids_tst1(i))),i)=1
    % a matriz de inputs � constitu�da por todas as features (palavras, 100
    % neste caso) de todos os samples (99 neste primeiro teste)
    featureInputs(:,i)=encode(features,im)'
    
    clear id
    clear im    
    
end
%% Inicializa��o da rede neuronal
neurons=30 % definir n�mero de neur�nios
net = patternnet(neurons); % criar a nn
view(net)

[net,tr] = train(net,featureInputs,T);


%% Treinar a rede neuronal
leaves2=[currentFolder '\Folhas_2']
cd(leaves2)

imgSet02 = imageSet(leaves2)

T2=[]
for i=1:imgSet02.Count % ciclo que vai criar as matrizes de input e targets
   
    [~,id,~] = fileparts(char(imgSet02.ImageLocation(i)))
    ids_tst2(i)=str2num(id)
    im=imread([id '.jpg'])

    % a matriz de targets � uma matriz com 1 nas posi��es das folhas em
    % quest�o e zeros e todas as outras
    T2(ids_cat(find(ids_sample==ids_tst2(i))),i)=1
    % a matriz de inputs � constitu�da por todas as features (palavras, 100
    % neste caso) de todos os samples (99 neste primeiro teste)
    
    featureInputs2(:,i)=encode(features,im)'
 
    clear id
    clear im    
    
end

%% Treinar a rede neuronal
% neurons=15 % definir n�mero de neur�nios
% trainFcn='trainscg'
% net.divideFcn = 'dividerand';
% net.divideParam.trainInd = 0.7;
% net.divideParam.valInd = 0.15;
% net.divideParam.testInd = 0.15;

% net=patternnet(neurons,trainFcn)

[net,tr] = train(net,featureInputs2,T2);
nntraintool

%% Testar a rede neuronal

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
test_3 = net(featureInput3);
%% Test


ii=1:99
figure

for i=1:20

        subplot(5,4,i)
        hold on
        plot(ii,test_3(:,i))
        
        [m ind]=max(test_3(:,i))
        plot(ind,1)
        T_Val(i)=ind
        hold off
end
        
T3
T_Val
