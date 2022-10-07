function [Y1,Y2,V,D1,U1,S,W] = CSSD_old(X1,X2, n1)
%CSSD common and specific subspaces decomposition



[N1,M1]=size(X1);
[N2,M2]=size(X2);
if M1~=M2
    error('Data must have equal number of samples (columns)');
else
    M=M1;
end

%% blanchiment pour ??viter les amplitudes diff??rentes
[U1,D1]=eig(1/M1*X1*X1');
D1=abs(D1);
Z1=D1^(-1/2)*U1'*X1;

[U2,D2]=eig(1/M1*X2*X2');
D2=abs(D2);
Z2=D2^(-1/2)*U2'*X2;

%cond(Di)
%cond(De)
%% decomposition

% construction des deux bases
C=Z1*Z2';
[V,S,W] = svd(C);

loads{1}=V*S;
loads{2}=W;
[sgns,loads] = sign_flip(loads,C);
W=loads{2};
V(:,1:n1)=loads{1}*S(1:min(N1,N2),1:min(N1,N2))^(-1);

Y1=V'*Z1;
Y2=W'*Z2;
% 
% Z3=V*Y1;
% X11=U1*(D1^(1/2))*Z3;
% X11=U1*Z3;