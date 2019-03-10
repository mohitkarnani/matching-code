function match=DA(sPref, oPref, slots, ranked)

%%
% Implementation of Gale-Shapley deferred acceptance algorithm. 
%
% Author: Mohit Karnani (mohit@nber.org)
%
% Inputs:
% sPref- students's preference sXo matrix (s- number of students). 
% i-th student's preferences for options are along i'th row.
%
% oPref- option's preference sXo matrix (o- number of options).
% j-th program's preferences for students are along j'th column.
%
% slots- (optional) oX1 vector with slots available in each option.
% If omitted, each option is assumed to have a single slot (as in M->W
% matching).
%
% ranked- (optional) indicator to indicate that sPref and oPref denote 
% ordered rankings instead of cardinal preferences.
%
% Output:
% match- sX1 vector of final matches. The i-th element of this vector is
% the number of program that matches i-th student.
% 

 if ~exist('slots','var')
    slots=ones(size(sPref,2),1);
 end
 
 sPref(:,slots==0)=-Inf;

 if exist('ranked','var')
    sPref=-sPref;
    oPref=-oPref;
 end

[s,o] = size(sPref);

[~, sRank] = sort(sPref,2,'desc');
sTrack=ones(s, 1);

Rejected=ones(s, 1);

while sum(Rejected)>0
    propIndex=sub2ind(size(sRank),[1:size(sPref,1)]',sTrack);
    Proposals=sRank(propIndex);

    Receptions=zeros(size(oPref));
    Receptions(sub2ind(size(oPref),[1:size(oPref,1)]',Proposals))=1;
    propScores=oPref.*Receptions;

    sortedA = sort(propScores,'desc');
    nthMax = sortedA((0:s:s*(o-1))+slots');
    Rejected = sum((propScores < nthMax) .* Receptions, 2);

    sTrack = sTrack + Rejected;
end

match=Proposals;

end