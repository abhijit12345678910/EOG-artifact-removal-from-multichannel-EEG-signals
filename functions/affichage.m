function affichage(varargin)
%
% SYNTAXE :
%           affichage(matrice,Fech)
%        ou affichage(matrice,Fech,'fichier_noms_electrodes')
%        ou affichage(matrice,Fech,cell_noms_electrodes)
%        ou affichage(matrice,Fech,64)
%
% Cette fonction permet l'affichage des voies de la variable passée en 1er argument.
% Chaque LIGNE de cette matrice correspond à UNE VOIE.
%
% Le second argument est la fréquence d'échantillonnage.
%
% Un troisiéme argument est facultatif:
% - Lorsque cet argument est absent, les noms des voies à afficher sont numérotés à partir de 1
% - Si cet argument est de type "cell", il s'agit d'une variable du
%   workspace contenant les noms des électrodes.
% - Lorsque l'argument vaut 64, les voies affichées ont pour noms :
%      {'Fp2';'F2';'FC2';'C2';'CP2';'P2';'O2';'AF4';'F4';'FC4';'C4';'CP4';'P4';'PO4';...
%     'F6';'FC6';'C6';'CP6';'P6';'AF8';'F8';'FT8';'T4';'TP8';'T6';'PO8';'FT10';'P10';'AFz';...
%     'Fz';'FCz';'Cz';'CPz';'Pz';'POz';'Oz';'Fp1';'F1';'FC1';'C1';'CP1';'P1';'O1';'AF3';'F3';...
%     'FC3';'C3';'CP3';'P3';'PO3';'F5';'FC5';'C5';'CP5';'P5';'AF7';'F7';'FT7';'T3';'TP7';'T5';'PO7';'FT9';'P9'}
% - Cet argument peut également désigner un fichier dans lequel sont contenus uniquement les noms des voies à afficher 
%   (les noms doivent être séparés par des espaces ou des tabulations, ou alors se situer sur des lignes différentes)
%
% (Le nombre de voies doit être inférieur ou égal à 64 lorsque le troisième argument vaut 64.
% Dans le cas où il y a moins de 64 voies à afficher et que varargin{3} vaut 64, seuls les premiers noms de la liste s'affichent.)
%
% version 15.07.2010
%

couleur=[1 1 1];

if nargin==2
    for ind=1:size(varargin{1},1)
        electrodes{ind,1}=num2str(ind);
    end
    Fech=varargin{2};
elseif nargin==3
    Fech=varargin{2};
    if iscell(varargin{3})
        electrodes=varargin{3};
    else
        if varargin{3}==64
            % noms des electrodes affichées dans cette ordre (à modifier selon le montage utilisé)
            electrodes= {'Fp2';'F2';'FC2';'C2';'CP2';'P2';'O2';'AF4';'F4';'FC4';'C4';'CP4';'P4';'PO4';...
            'F6';'FC6';'C6';'CP6';'P6';'AF8';'F8';'FT8';'T4';'TP8';'T6';'PO8';'FT10';'P10';'AFz';...
            'Fz';'FCz';'Cz';'CPz';'Pz';'POz';'Oz';'Fp1';'F1';'FC1';'C1';'CP1';'P1';'O1';'AF3';'F3';...
            'FC3';'C3';'CP3';'P3';'PO3';'F5';'FC5';'C5';'CP5';'P5';'AF7';'F7';'FT7';'T3';'TP7';'T5';'PO7';'FT9';'P9'};
        elseif exist(varargin{3},'file')
            try
                electrodes=textread(varargin{3},'%s','delimiter',['\t' ' ']);
            catch
                disp('ERREUR de lecture du fichier contenant le nom des électrodes!!');
                return;
            end
        else
            disp('ERREUR dans le 3ème argument de la fonction "affichage"!!');
            return;
        end
    end
else
    disp('ERREUR dans le nombre d''arguments de la fonction!!');
    return;
end

sig=varargin{1}; % signal à afficher

facteur_echelle=1; % valeur par défaut du facteur d'échelle pour modifier l'ordonnée des courbes

ancienne_valeur_nb_voies=11; % valeur par défaut du nombre de voies affichées

%amplitude_max=max(max(abs(sig)));
amplitude_max=500;

if size(sig,1)>length(electrodes)
    disp('ERREUR: il manque des noms d''électrodes!!');
    return;
end

% des espaces sont ajoutés dans les noms d'électrodes pour que tous les
% noms contiennent le même nombre de caractéres:
long_nom=0;
for i=1:length(electrodes)
    if length(electrodes{i})>long_nom;
        long_nom=length(electrodes{i});
    end
end
for i=1:length(electrodes)
    while length(electrodes{i})<long_nom;
        electrodes{i}=[' ' electrodes{i}];
    end
end
    
f = figure('Units','normalized',...
    'Position',[.1 .05 0.7 0.75],...
    'Renderer','painters',...
    'Toolbar','figure','NumberTitle','off',...
    'Name',['EEGviewer : ' inputname(1)],'Color',couleur);

subplot('Position',[.055 .11 .85 .845]);

bouton_precedent = uicontrol(f,'Style','pushbutton','FontSize',14,'String','<<','Units','normalized',...
    'Position',[.03 .02 .04 .04],'Callback',{@precedent},'ToolTipString','reculer de 10 secondes','ForegroundColor',[.1 .1 .9]);

bouton_suivant = uicontrol(f,'Style','pushbutton','FontSize',14,'String','>>','Units','normalized','Position',...
    [.93 .02 .04 .04],'Callback',{@suivant},'ToolTipString','avancer de 10 secondes','ForegroundColor',[.1 .1 .9]);

bouton_precedent_1 = uicontrol(f,'Style','pushbutton','FontSize',14,'String','<','Units','normalized',...
    'Position',[.085 .02 .04 .04],'Callback',{@precedent_1},'ToolTipString','reculer de 1 seconde','ForegroundColor',[.1 .1 .9]);

bouton_suivant_1 = uicontrol(f,'Style','pushbutton','FontSize',14,'String','>','Units','normalized','Position',...
    [.875 .02 .04 .04],'Callback',{@suivant_1},'ToolTipString','avancer de 1 seconde','ForegroundColor',[.1 .1 .9]);

bouton_courbes_precedentes = uicontrol(f,'Style','pushbutton','FontSize',10,'FontWeight','bold','String','/\','Units','normalized','Position',...
    [.93 .91 .04 .04],'Callback',{@courbes_prec},'ToolTipString','voies précedentes','ForegroundColor',[.0 .3 .0]);

bouton_courbes_suivantes = uicontrol(f,'Style','pushbutton','FontSize',10,'FontWeight','bold','String','\/','Units','normalized','Position',...
    [.93 .12 .04 .04],'Callback',{@courbes_suiv},'ToolTipString','voies suivantes','ForegroundColor',[.0 .3 .0]);

texte_facteur=uicontrol(f,'Style','text','FontSize',8,'String','facteur d''échelle','Units','normalized',...
    'Position',[.908 .7 .09 .03],'BackgroundColor',couleur,'HorizontalAlignment','center','ToolTipString','Facteur d''échelle > 0');

valeur_facteur_echelle = uicontrol(f,'Style','edit','String','1','Units','normalized','Position',[.93 .68 .04 .025],...
    'BackgroundColor',[1 1 1],'HorizontalAlignment','left','Callback',{@valeur_facteur},'FontSize',9);

uicontrol(f,'Style','text','FontSize',8,'String','nombre de voies','Units','normalized',...
    'Position',[.91 .5 .085 .03],'BackgroundColor',couleur,'HorizontalAlignment','center','ToolTipString','Nombre de voies à afficher verticalement');

val_nb_voies=uicontrol(f,'Style','edit','String',num2str(ancienne_valeur_nb_voies),'Units','normalized','Position',[.93 .48 .04 .025],...
    'BackgroundColor',[1 1 1],'HorizontalAlignment','left','Callback',{@valeur_nb_voies},'FontSize',9);

bouton_affichage_temps_total=uicontrol(f,'Style','pushbutton','FontSize',10,'String','Afficher toute la durée','Units','normalized','Position',...
    [.63 .02 .16 .04],'Callback',{@courbe_entiere},'ForegroundColor',[0 0 1]);

frame_affichage_perso=uicontrol(f,'Style','frame','Units','normalized','Position',[.185 .012 .22 .056]);%,'BackgroundColor',couleur);

texte_affichage_perso=uicontrol(f,'Style','text','FontSize',8,'String','Afficher de','Units','normalized',...
    'Position',[.195 .03 .058 .02],'HorizontalAlignment','left');

valeur_affichage_perso1=uicontrol(f,'Style','edit','Units','normalized','Position',[.255 .028 .03 .025],...
    'BackgroundColor',[1 1 1],'HorizontalAlignment','left','FontSize',9);

texte_affichage_perso2=uicontrol(f,'Style','text','FontSize',8,'String','s �','Units','normalized',...
    'Position',[.286 .03 .02 .02],'HorizontalAlignment','left');

valeur_affichage_perso2 = uicontrol(f,'Style','edit','Units','normalized','Position',[.307 .028 .03 .025],...
    'BackgroundColor',[1 1 1],'HorizontalAlignment','left','FontSize',9);

texte_affichage_perso3=uicontrol(f,'Style','text','FontSize',8,'String','s :','Units','normalized',...
    'Position',[.338 .03 .015 .02],'HorizontalAlignment','left');

bouton_affperso_ok=uicontrol(f,'Style','pushbutton','FontSize',8,'FontWeight','bold','String','OK','Units','normalized','Position',...
    [.355 .02 .04 .04],'Callback',{@affich_perso},'ToolTipString','valider l''affichage personnalisé','ForegroundColor',[.9 .1 .1]);

%%
Temps_sig=0; % temps correspondant au d�but du signal affich� (en secondes)
Voie_affich=1; % n� de la premi�re voie affich�e
affp=0; % d�finit si l'affichage temporel personnalis� a ��� utilis�
trace(Voie_affich,1,ancienne_valeur_nb_voies,0);
%annotation('line',[0.915 0.915],[0.11+0.845/(ancienne_valeur_nb_voies+1) 0.11+2*0.845/(ancienne_valeur_nb_voies+1)],'Tag','annline');
%annotation('textbox',[0.915 0.15 0.08 0.05],'String',[num2str(amplitude_max*facteur_echelle) ' microV'],'LineStyle','none','Tag','anntext');



%%

% trace les voies prem_voie � (prem_voie+nb_voies_affichees-1) sur 20 s � partir du point n� ti (ou trace toute la dur�e, ou jusqu'� tfp si non nul)
function trace(prem_voie,ti,nb_voies_affichees,tfp)
    ti=round(ti);
    if strcmp(get(bouton_affichage_temps_total,'String'),'Afficher 20s') % Attention : c'est le contraire qui s'affiche
        temps_affich=(size(sig,2)-1)/Fech;
    else
        temps_affich=20;
    end
    if tfp~=0
        temps_affich=(tfp-ti)/Fech;
    end
    if size(sig,1)<=nb_voies_affichees % cas o� il n'y a pas assez de voies � afficher 
        nb_voies_affichees=size(sig,1);
        set(val_nb_voies,'String',num2str(size(sig,1)));
        set(bouton_courbes_suivantes,'Enable','off');
        set(bouton_courbes_precedentes,'Enable','off');
    else
        set(bouton_courbes_suivantes,'Enable','on');
        set(bouton_courbes_precedentes,'Enable','on');        
    end
    if size(sig,2)<20*Fech+1 && tfp==0 % cas o� il y a moins de 20 s
        temps_affich=(size(sig,2)-1)/Fech;
        set(bouton_suivant,'Enable','off');
        set(bouton_precedent,'Enable','off');
        set(bouton_suivant_1,'Enable','off');
        set(bouton_precedent_1,'Enable','off');
    end
    
    redim_ymax=0; % variable définissant si le nom de la première voie s'affiche correctement
    redim_ymin=0; % variable définissant si le nom de la dernière voie s'affiche correctement
    
    % affichage des courbes:
    for k=prem_voie:prem_voie+nb_voies_affichees-1
        delta_y=nb_voies_affichees-k+prem_voie-1;
        if k==prem_voie % teste si toutes le valeurs de la 1ère voie sont <0, auquel cas 
                        % il faudra modifier l'affichage du nom de la voie en ordonnée 
            if ~any(sig(k,ti:ti+Fech*temps_affich)>=0)
                redim_ymax=1;
            end
            %Ymax=max(sig(k,ti:ti+Fech*temps_affich)+delta_y*amplitude_max*facteur_echelle); % valeur maximale à afficher
            if amplitude_max==0 % cas où toutes les voies sont nulles
                amplitude_max=.1;
                Ymax=delta_y*amplitude_max*facteur_echelle;
            end
        end
        if k==prem_voie+nb_voies_affichees-1 % teste si toutes le valeurs de la dernière voie sont >0, auquel 
                                                % cas il faudra modifier l'affichage du nom de la voie en ordonn�e
            if ~any(sig(k,ti:ti+Fech*temps_affich)<=0)
                redim_ymin=1;
            end
            Ymin=min(sig(k,ti:ti+Fech*temps_affich)+delta_y*amplitude_max*facteur_echelle); % valeur minimale � afficher
        end

        switch mod(k,5)
            case 1
                plot((ti-1)/Fech:1/Fech:(ti-1)/Fech+temps_affich,sig(k,ti:ti+Fech*temps_affich)+delta_y*amplitude_max*facteur_echelle);
            case 2
                plot((ti-1)/Fech:1/Fech:(ti-1)/Fech+temps_affich,sig(k,ti:ti+Fech*temps_affich)+delta_y*amplitude_max*facteur_echelle,'k');
            case 3
                plot((ti-1)/Fech:1/Fech:(ti-1)/Fech+temps_affich,sig(k,ti:ti+Fech*temps_affich)+delta_y*amplitude_max*facteur_echelle,'r');
            case 4
                plot((ti-1)/Fech:1/Fech:(ti-1)/Fech+temps_affich,sig(k,ti:ti+Fech*temps_affich)+delta_y*amplitude_max*facteur_echelle,'Color',[.1 .6 .1]);
            case 0
                plot((ti-1)/Fech:1/Fech:(ti-1)/Fech+temps_affich,sig(k,ti:ti+Fech*temps_affich)+delta_y*amplitude_max*facteur_echelle,'Color',[1 .45 .0]);
        end
        hold on;
    end
    
    for j=prem_voie:prem_voie+nb_voies_affichees-1 
        noms_voies(j+1-prem_voie,:)=electrodes{j};
    end
    % affichage des noms des voies:
    set(gca,'YTick',(0:nb_voies_affichees-1)*facteur_echelle*amplitude_max,'YTickLabel',noms_voies(end:-1:1,:));
    % l'�chelle des ordonn�es est adapt�e aux donn�es trac�es, pour pouvoir afficher les noms de toutes les voies:
    
    Ymax=nb_voies_affichees*amplitude_max*facteur_echelle;
    Ymin=-amplitude_max*facteur_echelle;
    if strcmp(get(bouton_affichage_temps_total,'String'),'Afficher 20s')&&affp==0 % Attention : c'est le contraire qui s'affiche
        axis([0 temps_affich+1/Fech (1-redim_ymin)*Ymin redim_ymax*(nb_voies_affichees-1)*facteur_echelle*amplitude_max+(1-redim_ymax)*Ymax]);
    elseif size(sig,2)<20*Fech&&affp==0 % cas o� il y a moins de 20 s
        axis([0 20+1/Fech (1-redim_ymin)*Ymin redim_ymax*(nb_voies_affichees-1)*facteur_echelle*amplitude_max+(1-redim_ymax)*Ymax]);
    else
        axis([Temps_sig Temps_sig+temps_affich+1/Fech (1-redim_ymin)*Ymin redim_ymax*(nb_voies_affichees-1)*facteur_echelle*amplitude_max+(1-redim_ymax)*Ymax]);
    end
        
    grid on;
    
    if strcmp(get(bouton_affichage_temps_total,'String'),'Afficher toute la durée')&&affp==0
        set(gca,'XTick',fix(Temps_sig):4:Temps_sig+22);
    end
    xlabel('Time(sec)','FontSize', 13);
    hold off;
    clear noms_voies; % au cas o� il y aura moins de voies � afficher suite � un clic sur un bouton
end


% affichage des valeurs temporelles pr�c�dentes (saut de 10s):  
function precedent(hObject, eventdata, handles)
    affp=0;
    Temps_sig=round(Temps_sig)-10;
    if Temps_sig<0
        Temps_sig=0;
    end
    if Temps_sig>(size(sig,2)-1)/Fech-20
        Temps_sig=(size(sig,2)-1)/Fech-20;
    end
    trace(Voie_affich,1+Temps_sig*Fech,str2num(get(val_nb_voies,'String')),0);
end


% affichage des valeurs temporelles suivantes (saut de 10s):
function suivant(hObject, eventdata, handles)
    affp=0;
    Temps_sig=Temps_sig+10;
    if Temps_sig>(size(sig,2)-1)/Fech-20
        Temps_sig=(size(sig,2)-1)/Fech-20;
    end
    trace(Voie_affich,1+Temps_sig*Fech,str2num(get(val_nb_voies,'String')),0);
end


% affichage des valeurs � partir de la seconde pr�c�dente:  
function precedent_1(hObject, eventdata, handles)
    affp=0;
    Temps_sig=round(Temps_sig-1);
    if Temps_sig<0
        Temps_sig=0;
    end
    if Temps_sig>(size(sig,2)-1)/Fech-20
        Temps_sig=(size(sig,2)-1)/Fech-20;
    end
    trace(Voie_affich,1+Temps_sig*Fech,str2num(get(val_nb_voies,'String')),0);
end


% affichage des valeurs jusqu'� la seconde suivante:
function suivant_1(hObject, eventdata, handles)
    affp=0;
    Temps_sig=Temps_sig+1;
    if Temps_sig>(size(sig,2)-1)/Fech-20
        Temps_sig=(size(sig,2)-1)/Fech-20;
    end
    trace(Voie_affich,1+Temps_sig*Fech,str2num(get(val_nb_voies,'String')),0);
end


% affichage des courbes suivantes:
function courbes_suiv(hObject, eventdata, handles)
    if str2num(get(val_nb_voies,'String'))<5
        Voie_affich=Voie_affich+1; % si moins de 5 voies sont affich�es
    else
        Voie_affich=Voie_affich+5;
    end
    if Voie_affich > size(sig,1)-str2num(get(val_nb_voies,'String'))+1 % cas o� les derni�res courbes sont atteintes
        Voie_affich=size(sig,1)-str2num(get(val_nb_voies,'String'))+1;
        if Voie_affich < 1
            Voie_affich=1;
        end
    end
    if affp==0
        if strcmp(get(bouton_affichage_temps_total,'String'),'Afficher 20s')
            trace(Voie_affich,1,str2num(get(val_nb_voies,'String')),0); % affichage de la dur�e totale
        else
            trace(Voie_affich,1+Temps_sig*Fech,str2num(get(val_nb_voies,'String')),0);
        end
    else
        affich_perso;
    end
end


% affichage des courbes pr�c�dentes:
function courbes_prec(hObject, eventdata, handles)
    if str2num(get(val_nb_voies,'String'))<5
        Voie_affich=Voie_affich-1; % si moins de 5 voies sont affich�es
    else
        Voie_affich=Voie_affich-5;
    end
    if Voie_affich < 1 % cas o� les premi�res courbes sont atteintes
        Voie_affich=1;
    end
    if affp==0
        if strcmp(get(bouton_affichage_temps_total,'String'),'Afficher 20s')
            trace(Voie_affich,1,str2num(get(val_nb_voies,'String')),0); % affichage de la dur�e totale
        else
            trace(Voie_affich,1+Temps_sig*Fech,str2num(get(val_nb_voies,'String')),0);
        end
    else
        affich_perso;
    end
end


% utilisation de la valeur du facteur d'�chelle
function valeur_facteur(hObject, eventdata, handles)
    facteur_echelle=str2num(get(hObject,'String'));
    if ~isequal(size(facteur_echelle),[1 1]) % le facteur d'�chelle ne doit pas �tre vide (ou un caract�re)
        facteur_echelle=1;
        set(hObject,'String','1');
    elseif facteur_echelle<=0  % valeur <0 impossible pour le facteur d'�chelle
        facteur_echelle=1;
        set(hObject,'String','1');
    end
    if affp==0
        if strcmp(get(bouton_affichage_temps_total,'String'),'Afficher 20s')
            trace(Voie_affich,1,str2num(get(val_nb_voies,'String')),0); % affichage de la dur�e totale
        else
            trace(Voie_affich,1+Temps_sig*Fech,str2num(get(val_nb_voies,'String')),0);
        end
    else
        affich_perso;
    end
    delete(findall(gcf,'Tag','annline'))
    delete(findall(gcf,'Tag','anntext'))
    %annotation('line',[0.915 0.915],[0.11+0.845/(ancienne_valeur_nb_voies+1) 0.11+2*0.845/(ancienne_valeur_nb_voies+1)],'Tag','annline');
    %annotation('textbox',[0.915 0.11+1.2*0.845/(ancienne_valeur_nb_voies+1) 0.08 0.05],'String',[num2str(amplitude_max*facteur_echelle) ' microV'],'LineStyle','none','Tag','anntext');

end


% s�lection du nombre de voies � afficher
function valeur_nb_voies(hObject, eventdata, handles)
    nb_voies_affichees=str2num(get(hObject,'String'));
    if ~isequal(size(nb_voies_affichees),[1 1]) % ne doit pas �tre vide (ou un caract�re)
        nb_voies_affichees=ancienne_valeur_nb_voies;
    elseif nb_voies_affichees<1  % valeur <1 impossible
        nb_voies_affichees=ancienne_valeur_nb_voies;
    end
    nb_voies_affichees=round(nb_voies_affichees); % au cas o� une valeur d�cimale est saisie
    set(hObject,'String',num2str(nb_voies_affichees));
    if Voie_affich+nb_voies_affichees-1>size(sig,1) % nombre de voies total d�pass� 
        nb_voies_affichees=min(size(sig,1),nb_voies_affichees);
        set(hObject,'String',num2str(nb_voies_affichees));
        Voie_affich=size(sig,1)-nb_voies_affichees+1;
        if Voie_affich<1
            Voie_affich=1;
        end
    end
    if affp==0
        if strcmp(get(bouton_affichage_temps_total,'String'),'Afficher 20s')
            trace(Voie_affich,1,nb_voies_affichees,0); % affichage de la dur�e totale
        else
            trace(Voie_affich,1+Temps_sig*Fech,nb_voies_affichees,0);
        end
    else
        affich_perso;
    end
    ancienne_valeur_nb_voies=nb_voies_affichees;
    delete(findall(gcf,'Tag','annline'))
    delete(findall(gcf,'Tag','anntext'))
    %annotation('line',[0.915 0.915],[0.11+0.845/(ancienne_valeur_nb_voies+1) 0.11+2*0.845/(ancienne_valeur_nb_voies+1)],'Tag','annline');
    %annotation('textbox',[0.915 0.11+1.2*0.845/(ancienne_valeur_nb_voies+1) 0.08 0.05],'String',[num2str(amplitude_max*facteur_echelle) ' microV'],'LineStyle','none','Tag','anntext');

end


% affichage des courbes sur toute leur dur�e
function courbe_entiere(hObject, eventdata, handles)
    affp=0;
    if strcmp(get(hObject,'String'),'Afficher toute la durée')
        set(hObject,'String','Afficher 20s');
        set(bouton_precedent,'Enable','off');
        set(bouton_suivant,'Enable','off');
        set(bouton_precedent_1,'Enable','off');
        set(bouton_suivant_1,'Enable','off');
        trace(Voie_affich,1,str2num(get(val_nb_voies,'String')),0);
    elseif strcmp(get(hObject,'String'),'Afficher 20s')
        set(hObject,'String','Afficher toute la dur�e');
        if size(sig,2)>=Fech
            set(bouton_precedent_1,'Enable','on');
            set(bouton_suivant_1,'Enable','on');
        end
        if size(sig,2)>=20*Fech
            set(bouton_precedent,'Enable','on');
            set(bouton_suivant,'Enable','on');
        end
        if Temps_sig>(size(sig,2)-1)/Fech-20 && size(sig,2)/Fech>=20
            Temps_sig=(size(sig,2)-1)/Fech-20;
        end
        if size(sig,2)/Fech<20
            Temps_sig=0;
        end
        trace(Voie_affich,1+Temps_sig*Fech,str2num(get(val_nb_voies,'String')),0);
    end
end


% affichage des courbes entre les dur�es sp�cifi�es
function affich_perso(hObject, eventdata, handles)
    td=str2double(get(valeur_affichage_perso1,'String'));
    tf=str2double(get(valeur_affichage_perso2,'String'));
    if ~isnan(tf)&&~isnan(td)&&tf>=0&&td>=0
        if Fech*tf>size(sig,2)
            tf=size(sig,2)/Fech;
            set(valeur_affichage_perso2,'String',num2str(tf));
        end
        if Fech*td>size(sig,2)
            td=size(sig,2)/Fech;
            set(valeur_affichage_perso1,'String',num2str(td));
        end
        if td>tf
            set(valeur_affichage_perso1,'String',num2str(tf));
            set(valeur_affichage_perso2,'String',num2str(td));
            td=tf;
            tf=str2double(get(valeur_affichage_perso2,'String'));
        end
        if td~=tf
            Temps_sig=td;
            affp=1;
            trace(Voie_affich,1+floor(td*Fech),str2num(get(val_nb_voies,'String')),floor(tf*Fech));
        else
            set(valeur_affichage_perso1,'String','');
            set(valeur_affichage_perso2,'String','');
        end
    else
        set(valeur_affichage_perso1,'String','');
        set(valeur_affichage_perso2,'String','');
    end
end

end