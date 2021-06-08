function[BestFirstMeans,WorstFirstMeans,BestSecondMeans,WorstSecondMeans,AllMeans,...
    AllNormality,BestNormality,WorstNormality,AllGroups,BestGroups,...
    WorstGroups,BestWorstDiff,FirstDiff,SecondDiff,FirstSecondDiff,...
    EleRecognitionMeans,EleRecog]=CompileLocalisationMeans(iccData,source)
%COMPIILELocalisationMeans Creates tables of localisation trial means.


% Create unsigned response errors
for n=1:2368;
    if source.RespAzi(n)<0, source.UnsignAzi(n) = (source.RespAzi(n))*-1; 
    else, source.UnsignAzi(n) = source.RespAzi(n);
    end
    if source.RespEle(n)<0, source.UnsignEle(n) = (source.RespEle(n))*-1;
    else, source.UnsignEle(n) = source.RespEle(n);
    end
end

% Specify response tolerances
AziTol = 15
EleTol = 22.5;
elevations = [45,0,-45];
increment = [1,6,11];

% Declare data comparison tables
best=source(find(source.HRTFState==1),:);
worst=source(find(source.HRTFState==0),:);
first=source(find(source.Trial<=20),:);
second=source(find(source.Trial>20),:);
bestfirst=source(find(and(source.HRTFState==1,source.Trial<=20)),:);
worstfirst=source(find(and(source.HRTFState==0,source.Trial<=20)),:);
bestsecond=source(find(and(source.HRTFState==1,source.Trial>20)),:);
worstsecond=source(find(and(source.HRTFState==0,source.Trial>20)),:);

%Declare significance tables
AllMeans = table();
BestMeans = table();
WorstMeans = table();
FirstMeans = table();
SecondMeans = table();
BestFirstMeans = table();
WorstFirstMeans = table();
BestSecondMeans = table();
WorstSecondMeans = table();
EleRecognitionMeans = table();
AllGroups = table();
BestGroups = table();
WorstGroups = table();
BestWorstDiff = table();
FirstDiff = table();
SecondDiff = table();
FirstSecondDiff = table();
EleRecog = table();

% Declare normality test tables
AllNormality = table();
BestNormality = table();
WorstNormality = table();

% For each participant
for i=1:21;
    % Find the data for all HRTFs
    
    AllMeans.Participant(i)=iccData.Participant(i);
    BestMeans.Participant(i)=iccData.Participant(i);
    WorstMeans.Participant(i)=iccData.Participant(i);
    FirstMeans.Participant(i)=iccData.Participant(i);
    SecondMeans.Participant(i)=iccData.Participant(i);
    BestFirstMeans.Participant(i)=iccData.Participant(i);
    WorstFirstMeans.Participant(i)=iccData.Participant(i);
    BestSecondMeans.Participant(i)=iccData.Participant(i);
    WorstSecondMeans.Participant(i)=iccData.Participant(i);
    EleRecognitionMeans.Participant(i)=iccData.Participant(i);
    
    for j=1:3;
        %ALL RESPONSES
        % Azimuth success rate
        AllMeans(i,(increment(j)+1))=array2table((length(find(and(...
            source.UnsignAzi<AziTol,and(source.Participant==iccData.Participant(i), ...
            source.TargEle==elevations(j)))))) / ...
            (length(find(and(source.Participant==iccData.Participant(i), ...
            source.TargEle==elevations(j))))) * 100);
        % Azimuth mean unsigned error
        AllMeans(i,(increment(j)+2))=array2table(mean(source.UnsignAzi(find(...
            and(source.Participant==iccData.Participant(i),...
            source.TargEle==elevations(j))))));
        % Elevation success rate
        AllMeans(i,(increment(j)+3))=array2table((length(find(and(...
            source.UnsignAzi<AziTol,and(...
            source.UnsignEle<EleTol,and(source.Participant==iccData.Participant(i),...
            source.TargEle==elevations(j))))))) / ...
            (length(find(and(source.Participant==iccData.Participant(i), ...
            source.TargEle==elevations(j))))) * 100);
        % Elevation mean unsigned error    
        AllMeans(i,(increment(j)+4))=array2table(mean(source.UnsignEle(find(...
            and(source.Participant==iccData.Participant(i),...
            source.TargEle==elevations(j))))));
        % Mean time taken
        AllMeans(i,(increment(j)+5))=array2table(mean(source.Time(find(...
            and(source.Participant==iccData.Participant(i),...
            source.TargEle==elevations(j))))));

        %BEST HRTF RESPONSES
        % Azimuth success rate
        BestMeans(i,(increment(j)+1))=array2table((length(find(and(...
            best.UnsignAzi<AziTol,and(best.Participant==iccData.Participant(i), ...
            best.TargEle==elevations(j)))))) / ...
            (length(find(and(best.Participant==iccData.Participant(i), ...
            best.TargEle==elevations(j))))) * 100);
        % Azimuth mean unsigned error
        BestMeans(i,(increment(j)+2))=array2table(mean(best.UnsignAzi(find(...
            and(best.Participant==iccData.Participant(i),...
            best.TargEle==elevations(j))))));
        % Elevation success rate
        BestMeans(i,(increment(j)+3))=array2table((length(find(and(...
            best.UnsignAzi<AziTol,and(...
            best.UnsignEle<EleTol,and(best.Participant==iccData.Participant(i),...
            best.TargEle==elevations(j))))))) / ...
            (length(find(and(best.Participant==iccData.Participant(i), ...
            best.TargEle==elevations(j))))) * 100);
        % Elevation mean unsigned error    
        BestMeans(i,(increment(j)+4))=array2table(mean(best.UnsignEle(find(...
            and(best.Participant==iccData.Participant(i),...
            best.TargEle==elevations(j))))));
        % Mean time taken
        BestMeans(i,(increment(j)+5))=array2table(mean(best.Time(find(...
            and(best.Participant==iccData.Participant(i),...
            best.TargEle==elevations(j))))));  

        %WORST HRTF RESPONSES
        % Azimuth success rate                
        WorstMeans(i,(increment(j)+1))=array2table((length(find(and(...
            worst.UnsignAzi<AziTol,and(worst.Participant==iccData.Participant(i), ...
            worst.TargEle==elevations(j)))))) / ...
            (length(find(and(worst.Participant==iccData.Participant(i), ...
            worst.TargEle==elevations(j))))) * 100);
        % Azimuth mean unsigned error
        WorstMeans(i,(increment(j)+2))=array2table(mean(worst.UnsignAzi(find(...
            and(worst.Participant==iccData.Participant(i),...
            worst.TargEle==elevations(j))))));
        % Elevation success rate
        WorstMeans(i,(increment(j)+3))=array2table((length(find(and(...
            worst.UnsignAzi<AziTol,and(...
            worst.UnsignEle<EleTol,and(worst.Participant==iccData.Participant(i),...
            worst.TargEle==elevations(j))))))) / ...
            (length(find(and(worst.Participant==iccData.Participant(i), ...
            worst.TargEle==elevations(j))))) * 100);
        % Elevation mean unsigned error    
        WorstMeans(i,(increment(j)+4))=array2table(mean(worst.UnsignEle(find(...
            and(worst.Participant==iccData.Participant(i),...
            worst.TargEle==elevations(j))))));
        % Mean time taken
        WorstMeans(i,(increment(j)+5))=array2table(mean(worst.Time(find(...
            and(worst.Participant==iccData.Participant(i),...
            worst.TargEle==elevations(j))))));  

        %FIRST RESPONSES
        % Azimuth success rate
        FirstMeans(i,(increment(j)+1))=array2table((length(find(and(...
            first.UnsignAzi<AziTol,and(first.Participant==iccData.Participant(i), ...
            first.TargEle==elevations(j)))))) / ...
            (length(find(and(first.Participant==iccData.Participant(i), ...
            first.TargEle==elevations(j))))) * 100);
        % Azimuth mean unsigned error
        FirstMeans(i,(increment(j)+2))=array2table(mean(first.UnsignAzi(find(...
            and(first.Participant==iccData.Participant(i),...
            first.TargEle==elevations(j))))));
        % Elevation success rate
        FirstMeans(i,(increment(j)+3))=array2table((length(find(and(...
            first.UnsignAzi<AziTol,and(...
            first.UnsignEle<EleTol,and(first.Participant==iccData.Participant(i),...
            first.TargEle==elevations(j))))))) / ...
            (length(find(and(first.Participant==iccData.Participant(i), ...
            first.TargEle==elevations(j))))) * 100);
        % Elevation mean unsigned error    
        FirstMeans(i,(increment(j)+4))=array2table(mean(first.UnsignEle(find(...
            and(first.Participant==iccData.Participant(i),...
            first.TargEle==elevations(j))))));
        % Mean time taken
        FirstMeans(i,(increment(j)+5))=array2table(mean(first.Time(find(...
            and(first.Participant==iccData.Participant(i),...
            first.TargEle==elevations(j))))));  

        %SECOND RESPONSES
        % Azimuth success rate                
        SecondMeans(i,(increment(j)+1))=array2table((length(find(and(...
            second.UnsignAzi<AziTol,and(second.Participant==iccData.Participant(i), ...
            second.TargEle==elevations(j)))))) / ...
            (length(find(and(second.Participant==iccData.Participant(i), ...
            second.TargEle==elevations(j))))) * 100);
        % Azimuth mean unsigned error
        SecondMeans(i,(increment(j)+2))=array2table(mean(second.UnsignAzi(find(...
            and(second.Participant==iccData.Participant(i),...
            second.TargEle==elevations(j))))));
        % Elevation success rate
        SecondMeans(i,(increment(j)+3))=array2table((length(find(and(...
            second.UnsignAzi<AziTol,and(...
            second.UnsignEle<EleTol,and(second.Participant==iccData.Participant(i),...
            second.TargEle==elevations(j))))))) / ...
            (length(find(and(second.Participant==iccData.Participant(i), ...
            second.TargEle==elevations(j))))) * 100);
        % Elevation mean unsigned error    
        SecondMeans(i,(increment(j)+4))=array2table(mean(second.UnsignEle(find(...
            and(second.Participant==iccData.Participant(i),...
            second.TargEle==elevations(j))))));
        % Mean time taken
        SecondMeans(i,(increment(j)+5))=array2table(mean(second.Time(find(...
            and(second.Participant==iccData.Participant(i),...
            second.TargEle==elevations(j))))));
        
        %BEST&FIRST RESPONSES
        % Azimuth success rate                
        BestFirstMeans(i,(increment(j)+1))=array2table((length(find(and(...
            bestfirst.UnsignAzi<AziTol,and(bestfirst.Participant==iccData.Participant(i), ...
            bestfirst.TargEle==elevations(j)))))) / ...
            (length(find(and(bestfirst.Participant==iccData.Participant(i), ...
            bestfirst.TargEle==elevations(j))))) * 100);
        % Azimuth mean unsigned error
        BestFirstMeans(i,(increment(j)+2))=array2table(mean(bestfirst.UnsignAzi(find(...
            and(bestfirst.Participant==iccData.Participant(i),...
            bestfirst.TargEle==elevations(j))))));
        % Elevation success rate
        BestFirstMeans(i,(increment(j)+3))=array2table((length(find(and(...
            bestfirst.UnsignAzi<AziTol,and(...
            bestfirst.UnsignEle<EleTol,and(bestfirst.Participant==iccData.Participant(i),...
            bestfirst.TargEle==elevations(j))))))) / ...
            (length(find(and(bestfirst.Participant==iccData.Participant(i), ...
            bestfirst.TargEle==elevations(j))))) * 100);
        % Elevation mean unsigned error    
        BestFirstMeans(i,(increment(j)+4))=array2table(mean(bestfirst.UnsignEle(find(...
            and(bestfirst.Participant==iccData.Participant(i),...
            bestfirst.TargEle==elevations(j))))));
        % Mean time taken
        BestFirstMeans(i,(increment(j)+5))=array2table(mean(bestfirst.Time(find(...
            and(bestfirst.Participant==iccData.Participant(i),...
            bestfirst.TargEle==elevations(j))))));
        
        %WORST&FIRST RESPONSES
        % Azimuth success rate                
        WorstFirstMeans(i,(increment(j)+1))=array2table((length(find(and(...
            worstfirst.UnsignAzi<AziTol,and(worstfirst.Participant==iccData.Participant(i), ...
            worstfirst.TargEle==elevations(j)))))) / ...
            (length(find(and(worstfirst.Participant==iccData.Participant(i), ...
            worstfirst.TargEle==elevations(j))))) * 100);
        % Azimuth mean unsigned error
        WorstFirstMeans(i,(increment(j)+2))=array2table(mean(worstfirst.UnsignAzi(find(...
            and(worstfirst.Participant==iccData.Participant(i),...
            worstfirst.TargEle==elevations(j))))));
        % Elevation success rate
        WorstFirstMeans(i,(increment(j)+3))=array2table((length(find(and(...
            worstfirst.UnsignAzi<AziTol,and(...
            worstfirst.UnsignEle<EleTol,and(worstfirst.Participant==iccData.Participant(i),...
            worstfirst.TargEle==elevations(j))))))) / ...
            (length(find(and(worstfirst.Participant==iccData.Participant(i), ...
            worstfirst.TargEle==elevations(j))))) * 100);
        % Elevation mean unsigned error    
        WorstFirstMeans(i,(increment(j)+4))=array2table(mean(worstfirst.UnsignEle(find(...
            and(worstfirst.Participant==iccData.Participant(i),...
            worstfirst.TargEle==elevations(j))))));
        % Mean time taken
        WorstFirstMeans(i,(increment(j)+5))=array2table(mean(worstfirst.Time(find(...
            and(worstfirst.Participant==iccData.Participant(i),...
            worstfirst.TargEle==elevations(j))))));
        
        %BEST&SECOND RESPONSES
        % Azimuth success rate                
        BestSecondMeans(i,(increment(j)+1))=array2table((length(find(and(...
            bestsecond.UnsignAzi<AziTol,and(bestsecond.Participant==iccData.Participant(i), ...
            bestsecond.TargEle==elevations(j)))))) / ...
            (length(find(and(bestsecond.Participant==iccData.Participant(i), ...
            bestsecond.TargEle==elevations(j))))) * 100);
        % Azimuth mean unsigned error
        BestSecondMeans(i,(increment(j)+2))=array2table(mean(bestsecond.UnsignAzi(find(...
            and(bestsecond.Participant==iccData.Participant(i),...
            bestsecond.TargEle==elevations(j))))));
        % Elevation success rate
        BestSecondMeans(i,(increment(j)+3))=array2table((length(find(and(...
            bestsecond.UnsignAzi<AziTol,and(...
            bestsecond.UnsignEle<EleTol,and(bestsecond.Participant==iccData.Participant(i),...
            bestsecond.TargEle==elevations(j))))))) / ...
            (length(find(and(bestsecond.Participant==iccData.Participant(i), ...
            bestsecond.TargEle==elevations(j))))) * 100);
        % Elevation mean unsigned error    
        BestSecondMeans(i,(increment(j)+4))=array2table(mean(bestsecond.UnsignEle(find(...
            and(bestsecond.Participant==iccData.Participant(i),...
            bestsecond.TargEle==elevations(j))))));
        % Mean time taken
        BestSecondMeans(i,(increment(j)+5))=array2table(mean(bestsecond.Time(find(...
            and(bestsecond.Participant==iccData.Participant(i),...
            bestsecond.TargEle==elevations(j))))));
        
        %WORST&SECOND RESPONSES
        % Azimuth success rate                
        WorstSecondMeans(i,(increment(j)+1))=array2table((length(find(and(...
            worstsecond.UnsignAzi<AziTol,and(worstsecond.Participant==iccData.Participant(i), ...
            worstsecond.TargEle==elevations(j)))))) / ...
            (length(find(and(worstsecond.Participant==iccData.Participant(i), ...
            worstsecond.TargEle==elevations(j))))) * 100);
        % Azimuth mean unsigned error
        WorstSecondMeans(i,(increment(j)+2))=array2table(mean(worstsecond.UnsignAzi(find(...
            and(worstsecond.Participant==iccData.Participant(i),...
            worstsecond.TargEle==elevations(j))))));
        % Elevation success rate
        WorstSecondMeans(i,(increment(j)+3))=array2table((length(find(and(...
            worstsecond.UnsignAzi<AziTol,and(...
            worstsecond.UnsignEle<EleTol,and(worstsecond.Participant==iccData.Participant(i),...
            worstsecond.TargEle==elevations(j))))))) / ...
            (length(find(and(worstsecond.Participant==iccData.Participant(i), ...
            worstsecond.TargEle==elevations(j))))) * 100);
        % Elevation mean unsigned error    
        WorstSecondMeans(i,(increment(j)+4))=array2table(mean(worstsecond.UnsignEle(find(...
            and(worstsecond.Participant==iccData.Participant(i),...
            worstsecond.TargEle==elevations(j))))));
        % Mean time taken
        WorstSecondMeans(i,(increment(j)+5))=array2table(mean(worstsecond.Time(find(...
            and(worstsecond.Participant==iccData.Participant(i),...
            worstsecond.TargEle==elevations(j))))));        
    end
    
    AllMeans.AllTimes(i)=mean(source.Time(find(...
        source.Participant==iccData.Participant(i))));
    BestMeans.AllTimes(i)=mean(best.Time(find(...
        best.Participant==iccData.Participant(i))));
    WorstMeans.AllTimes(i)=mean(worst.Time(find(...
        worst.Participant==iccData.Participant(i))));  
    FirstMeans.AllTimes(i)=mean(first.Time(find(...
        first.Participant==iccData.Participant(i))));  
    SecondMeans.AllTimes(i)=mean(second.Time(find(...
        second.Participant==iccData.Participant(i))));
    BestFirstMeans.AllTimes(i)=mean(bestfirst.Time(find(...
        bestfirst.Participant==iccData.Participant(i))));
    WorstFirstMeans.AllTimes(i)=mean(worstfirst.Time(find(...
        worstfirst.Participant==iccData.Participant(i))));  
    BestSecondMeans.AllTimes(i)=mean(bestsecond.Time(find(...
        bestsecond.Participant==iccData.Participant(i))));
    WorstSecondMeans.AllTimes(i)=mean(worstsecond.Time(find(...
        worstsecond.Participant==iccData.Participant(i))));      
  
    % Elevation success rate
    EleRecognitionMeans(i,2)=array2table((length(find...
        (and(source.UnsignAzi<AziTol,and(or(source.UnsignEle<EleTol,source.RespEle>67),and(source.Participant==iccData.Participant(i),source.TargEle==45)))))) / ...
        (length(find(and(source.Participant==iccData.Participant(i),source.TargEle==45)))) * 100)
    EleRecognitionMeans(i,3)=array2table((length(find...
        (and(source.UnsignAzi<AziTol,and(or(source.UnsignEle<EleTol,source.RespEle<-67),and(source.Participant==iccData.Participant(i),source.TargEle==-45)))))) / ...
        (length(find(and(source.Participant==iccData.Participant(i),source.TargEle==-45)))) * 100)
    EleRecognitionMeans(i,4)=array2table((length(find...
        (and(best.UnsignAzi<AziTol,and(or(best.UnsignEle<EleTol,best.RespEle>67),and(best.Participant==iccData.Participant(i),best.TargEle==45)))))) / ...
        (length(find(and(best.Participant==iccData.Participant(i),best.TargEle==45)))) * 100)
    EleRecognitionMeans(i,5)=array2table((length(find...
        (and(best.UnsignAzi<AziTol,and(or(best.UnsignEle<EleTol,best.RespEle<-67),and(best.Participant==iccData.Participant(i),best.TargEle==-45)))))) / ...
        (length(find(and(best.Participant==iccData.Participant(i),best.TargEle==-45)))) * 100)
    EleRecognitionMeans(i,6)=array2table((length(find...
        (and(worst.UnsignAzi<AziTol,and(or(worst.UnsignEle<EleTol,worst.RespEle>67),and(worst.Participant==iccData.Participant(i),worst.TargEle==45)))))) / ...
        (length(find(and(worst.Participant==iccData.Participant(i),worst.TargEle==45)))) * 100)
    EleRecognitionMeans(i,7)=array2table((length(find...
        (and(worst.UnsignAzi<AziTol,and(or(worst.UnsignEle<EleTol,worst.RespEle<-67),and(worst.Participant==iccData.Participant(i),worst.TargEle==-45)))))) / ...
        (length(find(and(worst.Participant==iccData.Participant(i),worst.TargEle==-45)))) * 100)    
    
end



for k=1:16
    %Compare Groups by all, best and worst HRTF results
    p = kruskalwallis(AllMeans{2:21,k+1},iccData.Group(2:21),'off');
    AllGroups(1,k)=array2table(p);
    p = kruskalwallis(BestMeans{2:21,k+1},iccData.Group(2:21),'off');
    BestGroups(1,k)=array2table(p);    
    p = kruskalwallis(WorstMeans{2:21,k+1},iccData.Group(2:21),'off');
    WorstGroups(1,k)=array2table(p);      
    
    %Compare best and worst HRTF differences
    [p,h]=signrank(BestMeans{2:21,k+1},WorstMeans{2:21,k+1});
    BestWorstDiff(1,k)=array2table(p);
    BestWorstDiff(2,k)=array2table(h);  
    
    %Compare best first against
    [p,h]=signrank(BestFirstMeans{2:21,k+1},WorstFirstMeans{2:21,k+1});
    FirstDiff(1,k)=array2table(p);
    FirstDiff(2,k)=array2table(h); 
    
    [p,h]=signrank(BestSecondMeans{2:21,k+1},WorstSecondMeans{2:21,k+1});
    SecondDiff(1,k)=array2table(p);
    SecondDiff(2,k)=array2table(h);
    
    [p,h]=signrank(FirstMeans{2:21,k+1},SecondMeans{2:21,k+1});
    FirstSecondDiff(1,k)=array2table(p);
    FirstSecondDiff(2,k)=array2table(h); 
    
    
    
    
    
    if k==6 | k==11 | k==16 | k==17;
        [h,p]=adtest(AllMeans{2:21,k+1},'Distribution','logn');
        AllNormality(1,k)=array2table(p);
        AllNormality(2,k)=array2table(h);
        [h,p]=adtest(BestMeans{2:21,k+1},'Distribution','logn');
        BestNormality(1,k)=array2table(p);
        BestNormality(2,k)=array2table(h);
        [h,p]=adtest(WorstMeans{2:21,k+1},'Distribution','logn');
        WorstNormality(1,k)=array2table(p);
        WorstNormality(2,k)=array2table(h);        
    else
        [h,p]=adtest(AllMeans{2:21,k+1},'Distribution','norm');
        AllNormality(1,k)=array2table(p);
        AllNormality(2,k)=array2table(h);
        [h,p]=adtest(BestMeans{2:21,k+1},'Distribution','norm');
        BestNormality(1,k)=array2table(p);
        BestNormality(2,k)=array2table(h);
        [h,p]=adtest(WorstMeans{2:21,k+1},'Distribution','norm');
        WorstNormality(1,k)=array2table(p);
        WorstNormality(2,k)=array2table(h); 
    end
end

% Add variable names
MeanNames = {'Participant','UpAziRate','UpAziError','UpEleRate',...
    'UpEleError','UpTime','LevelAziRate','LevelAziError','LevelEleRate',...
    'LevelEleError','LevelTime','DownAziRate','DownAziError',...
    'DownEleRate','DownEleError','DownTime','AllTimes'};
StatNames=MeanNames(2:17);
AllMeans.Properties.VariableNames = MeanNames;
BestMeans.Properties.VariableNames = MeanNames;
WorstMeans.Properties.VariableNames = MeanNames;
FirstMeans.Properties.VariableNames = MeanNames;
SecondMeans.Properties.VariableNames = MeanNames;
AllNormality.Properties.VariableNames = StatNames;
BestNormality.Properties.VariableNames = StatNames;
WorstNormality.Properties.VariableNames = StatNames;
AllGroups.Properties.VariableNames = StatNames;
BestGroups.Properties.VariableNames = StatNames;
WorstGroups.Properties.VariableNames = StatNames;
BestWorstDiff.Properties.VariableNames = StatNames;
FirstDiff.Properties.VariableNames = StatNames;
SecondDiff.Properties.VariableNames = StatNames;
FirstSecondDiff.Properties.VariableNames = StatNames;



%Plot comparison figures for azi accuracy, elev accuracy and response time
figure
titlesize = 18;
for l=1:9
    subplot(3,3,l)
    

    
    switch l
        case 1;
            boxplot([BestMeans.UpAziRate,WorstMeans.UpAziRate])
            title('Azimuth accuracy in upper stratum (45°)','FontSize',titlesize);
        case 2;
            boxplot([BestMeans.UpEleRate,WorstMeans.UpEleRate])            
            title('Elevation accuracy in upper stratum (45°)','FontSize',titlesize);
        case 3;
            boxplot([BestMeans.UpTime,WorstMeans.UpTime])
            title('Mean response time in upper stratum (45°)','FontSize',titlesize);
        case 4;
            boxplot([BestMeans.LevelAziRate,WorstMeans.LevelAziRate])            
            title('Azimuth accuracy in middle stratum (0°)','FontSize',titlesize);
        case 5;
            ax.Color = 'c';
            boxplot([BestMeans.LevelEleRate,WorstMeans.LevelEleRate])                      
            title('Elevation accuracy in middle stratum (0°)','FontSize',titlesize);
        case 6;
            boxplot([BestMeans.LevelTime,WorstMeans.LevelTime])
            title('Mean response time in middle stratum (0°)','FontSize',titlesize);                        
        case 7;
            boxplot([BestMeans.DownAziRate,WorstMeans.DownAziRate])
            title('Azimuth accuracy in lower stratum (-45°)','FontSize',titlesize);
        case 8;
            boxplot([BestMeans.DownEleRate,WorstMeans.DownEleRate])
            title('Elevation accuracy in lower stratum (-45°)','FontSize',titlesize);
        case 9;
            boxplot([BestMeans.DownTime,WorstMeans.DownTime])
            title('Mean response time in lower stratum (-45°)','FontSize',titlesize);
    end

    set(gca,'FontSize',14,'FontName', 'Helvetica')
    ax=gca;
    ax.LineWidth = 1.25;
    ax.Box = 'off'
    ax.Color = 'w'
    ax.XColor = 'k'
    ax.XColorMode = 'manual'
    ax.YColor = 'k'
    ax.YColorMode = 'manual'
    ax.YGrid = 'on'
    set(ax,'xticklabel',{"Best","Worst"})    
    ax.YAxis.LineWidth=2.5
    ax.XAxis.LineWidth=2.5
    
    if l==3 | l==6 | l==9
        ax.YLim = [0 50]
        ax.YAxis.Label.String = 'Time (secs)';
        ax.YAxis.Label.FontWeight = 'bold';
        set(findobj(gca,'tag','Box'), 'Color', [0 0 0.5], 'LineWidth', 2);
        ax.XAxis.Label.String = 'HRTF Set';
        ax.XAxis.Label.FontWeight = 'bold'; 
    else if l ==1 | l==4 | l==7
        ax.YLim = [-10 110]
        ax.YAxis.Label.String = 'Responses within +/-15° (%)';
        ax.YAxis.Label.FontWeight = 'bold';
        set(findobj(gca,'tag','Box'), 'Color', [1 0.6 0], 'LineWidth', 2);
        ax.XAxis.Label.String = 'HRTF Set';
        ax.XAxis.Label.FontWeight = 'bold'; 
        else
            ax.YLim = [-10 110]
            ax.YAxis.Label.String = 'Responses within +/-22.5° (%)';
            ax.YAxis.Label.FontWeight = 'bold';
            set(findobj(gca,'tag','Box'), 'Color', [0 0.5 0], 'LineWidth', 2);
            ax.XAxis.Label.String = 'HRTF Set';
            ax.XAxis.Label.FontWeight = 'bold';
        end
    end
    
end

%Plot comparison figures for azi accuracy, elev accuracy and response time
figure
titlesize = 18;
for m=1:9
    subplot(3,3,m)
    
    switch m
        case 1;
            boxplot([FirstMeans.UpAziRate,SecondMeans.UpAziRate])
            title('Azimuth accuracy in upper stratum (45°)','FontSize',titlesize);
        case 2;
            boxplot([FirstMeans.UpEleRate,SecondMeans.UpEleRate])            
            title('Elevation accuracy in upper stratum (45°)','FontSize',titlesize);
        case 3;
            ax.Color = 'c';
            boxplot([FirstMeans.UpTime,SecondMeans.UpTime])
            title('Mean response time in upper stratum (45°)','FontSize',titlesize);
            ax=gca;
        case 4;
            ax.Color = 'c';
            boxplot([FirstMeans.LevelAziRate,SecondMeans.LevelAziRate])            
            title('Azimuth accuracy in middle stratum (0°)','FontSize',titlesize);  
        case 5;
            boxplot([FirstMeans.LevelEleRate,SecondMeans.LevelEleRate])                      
            title('Elevation accuracy in middle stratum (0°)','FontSize',titlesize);
        case 6;
            boxplot([FirstMeans.LevelTime,SecondMeans.LevelTime])
            title('Mean response time in middle stratum (0°)','FontSize',titlesize);
        case 7;
            ax.Color = 'c';
            boxplot([FirstMeans.DownAziRate,SecondMeans.DownAziRate])
            title('Azimuth accuracy in lower stratum (-45°)','FontSize',titlesize);
        case 8;
            boxplot([FirstMeans.DownEleRate,SecondMeans.DownEleRate])
            title('Elevation accuracy in lower stratum (-45°)','FontSize',titlesize);
        case 9;
            boxplot([FirstMeans.DownTime,SecondMeans.DownTime])
            title('Mean response time in lower stratum (-45°)','FontSize',titlesize);        
    end

    set(gca,'FontSize',14,'FontName', 'Helvetica')
    ax=gca;
    ax.LineWidth = 1.25;
    ax.Box = 'off'
    ax.Color = 'w'
    ax.XColor = 'k'
    ax.XColorMode = 'manual'
    ax.YColor = 'k'
    ax.YColorMode = 'manual'
    ax.YGrid = 'on'
    set(ax,'xticklabel',{"First","Second"})    
    ax.YAxis.LineWidth=2.5
    ax.XAxis.LineWidth=2.5
    
    if m==3 | m==6 | m==9
        ax.YLim = [0 50]
        ax.YAxis.Label.String = 'Time (secs)';
        ax.YAxis.Label.FontWeight = 'bold';
        set(findobj(gca,'tag','Box'), 'Color', [0 0 0.5], 'LineWidth', 2);
        ax.XAxis.Label.String = 'Session half';
        ax.XAxis.Label.FontWeight = 'bold'; 
    else if m ==1 | m==4 | m==7
        ax.YLim = [-10 110]
        ax.YAxis.Label.String = 'Responses within +/-15° (%)';
        ax.YAxis.Label.FontWeight = 'bold';
        set(findobj(gca,'tag','Box'), 'Color', [1 0.6 0], 'LineWidth', 2);
        ax.XAxis.Label.String = 'Session Half';
        ax.XAxis.Label.FontWeight = 'bold'; 
        else
            ax.YLim = [-10 110]
            ax.YAxis.Label.String = 'Responses within +/-22.5° (%)';
            ax.YAxis.Label.FontWeight = 'bold';
            set(findobj(gca,'tag','Box'), 'Color', [0 0.5 0], 'LineWidth', 2);
            ax.XAxis.Label.String = 'Session Half';
            ax.XAxis.Label.FontWeight = 'bold';
        end
    end
    
end

%Plot comparison figures for azi accuracy, elev accuracy and response time
figure
titlesize = 14;
for q=1:9
    subplot(3,3,q)
    

    
    switch q
        case 1;
            bChart=bar(AllMeans.UpAziRate(2:21),'FaceColor','flat')
            title('Azimuth accuracy in upper stratum (45°)','FontSize',titlesize);
        case 2;
            bChart=bar(AllMeans.UpEleRate(2:21),'FaceColor','flat')           
            title('Elevation accuracy in upper stratum (45°)','FontSize',titlesize);
        case 3;
            bChart=bar(AllMeans.UpTime(2:21),'FaceColor','flat')
            title('Mean response time in upper stratum (45°)','FontSize',titlesize);
            ax=gca;
        case 4;
            bChart=bar(AllMeans.LevelAziRate(2:21),'FaceColor','flat')            
            title('Azimuth accuracy in middle stratum (0°)','FontSize',titlesize);  
        case 5;
            bChart=bar(AllMeans.LevelEleRate(2:21),'FaceColor','flat')
            title('Elevation accuracy in middle stratum (0°)','FontSize',titlesize);
        case 6;
            bChart=bar(AllMeans.LevelTime(2:21),'FaceColor','flat')
            title('Mean response time in middle stratum (0°)','FontSize',titlesize);
        case 7;
            bChart=bar(AllMeans.DownAziRate(2:21),'FaceColor','flat')
            title('Azimuth accuracy in lower stratum (-45°)','FontSize',titlesize);
        case 8;
            bChart=bar(AllMeans.DownEleRate(2:21),'FaceColor','flat')
            title('Elevation accuracy in lower stratum (-45°)','FontSize',titlesize);
        case 9;
            bChart=bar(AllMeans.DownTime(2:21),'FaceColor','flat')
            title('Mean response time in lower stratum (-45°)','FontSize',titlesize);
    end

    bChart.CData(2,:)=[1.0 0.2 0.0]
    bChart.CData(3,:)=[1.0 0.2 0.0]
    bChart.CData(7,:)=[1.0 0.2 0.0]
    bChart.CData(9,:)=[1.0 0.2 0.0]
    bChart.CData(11,:)=[1.0 0.2 0.0]
    bChart.CData(12,:)=[1.0 0.2 0.0]
    bChart.CData(19,:)=[1.0 0.2 0.0]
    
    bChart.CData(6,:)=[1.0 1.0 0.0]
    bChart.CData(10,:)=[1.0 1.0 0.0]
    bChart.CData(14,:)=[1.0 1.0 0.0]
    bChart.CData(16,:)=[1.0 1.0 0.0]
    bChart.CData(20,:)=[1.0 1.0 0.0]
    
    bChart.CData(1,:)=[0.0 0.75 0.0]
    bChart.CData(4,:)=[0.0 0.75 0.0]
    bChart.CData(5,:)=[0.0 0.75 0.0]
    bChart.CData(8,:)=[0.0 0.75 0.0]
    bChart.CData(13,:)=[0.0 0.75 0.0]
    bChart.CData(15,:)=[0.0 0.75 0.0]
    bChart.CData(17,:)=[0.0 0.75 0.0]
    bChart.CData(18,:)=[0.0 0.75 0.0]


    
      
        
    set(gca,'FontSize',12,'FontName', 'Helvetica')
    ax=gca;
    ax.LineWidth = 1.25;
    ax.Box = 'off'
    ax.Color = 'w'
    ax.XColor = 'k'
    ax.XColorMode = 'manual'
    ax.YColor = 'k'
    ax.YColorMode = 'manual'
    ax.YGrid = 'on'
    ax.XTick = [1:20]
    ax.XTickMode='manual'
    ax.XTickLabelMode='manual'
    
    ax.XTickLabel=char(iccData.Participant(2:21))
    ax.YAxis.LineWidth=2.5
    ax.XAxis.LineWidth=2.5
    
    if q==3 | q==6 | q==9
        ax.YLim = [0 40]
        ax.YAxis.Label.String = 'Time (secs)';
        ax.YAxis.Label.FontWeight = 'bold';
      
        ax.XAxis.Label.String = 'Participant';
        ax.XAxis.Label.FontWeight = 'bold'; 
    else if q ==1 | q==4 | q==7
        ax.YLim = [0 100]
        ax.YAxis.Label.String = 'Responses within +/-15° (%)';
        ax.YAxis.Label.FontWeight = 'bold';
        ax.XAxis.Label.String = 'Participant';
        ax.XAxis.Label.FontWeight = 'bold'; 
        else
            ax.YLim = [0 100]
            ax.YAxis.Label.String = 'Responses within +/-22.5° (%)';
            ax.YAxis.Label.FontWeight = 'bold';
            ax.XAxis.Label.String = 'Participant';
            ax.XAxis.Label.FontWeight = 'bold';
        end
    end
    
end

    [p,h]=signrank(EleRecognitionMeans.Var4,EleRecognitionMeans.Var6)
        EleRecog(1,1)=array2table(p);
        EleRecog(2,1)=array2table(h); 
    [p,h]=signrank(EleRecognitionMeans.Var5,EleRecognitionMeans.Var7)
        EleRecog(2,1)=array2table(p);
        EleRecog(2,2)=array2table(h); 

figure

subplot(1,2,1)
boxplot([EleRecognitionMeans.Var4,EleRecognitionMeans.Var6])
title('Elevation accuracy in upper stratum (45°)','FontSize',titlesize); 
set(gca,'FontSize',12,'FontName', 'Helvetica')
ax=gca;
ax.LineWidth = 1.25;
ax.Box = 'off'
ax.Color = 'w'
ax.XColor = 'k'
ax.XColorMode = 'manual'
ax.YColor = 'k'
ax.YColorMode = 'manual'
ax.YGrid = 'on'
set(ax,'xticklabel',{"Best","Worst"})    
ax.YAxis.LineWidth=2.5
ax.XAxis.LineWidth=2.5
ax.YLim = [-10 110]
ax.YAxis.Label.String = 'Responses within +/-22.5° (%)';
ax.YAxis.Label.FontWeight = 'bold';
set(findobj(gca,'tag','Box'), 'Color', [0 0.5 0], 'LineWidth', 2);
ax.XAxis.Label.String = 'HRTF Set';
ax.XAxis.Label.FontWeight = 'bold';

subplot(1,2,2)
boxplot([EleRecognitionMeans.Var5,EleRecognitionMeans.Var7])
title('Elevation accuracy in lower stratum (-45°)','FontSize',titlesize,'FontSize',titlesize); 
set(gca,'FontSize',12,'FontName', 'Helvetica')
ax=gca;
ax.LineWidth = 1.25;
ax.Box = 'off'
ax.Color = 'w'
ax.XColor = 'k'
ax.XColorMode = 'manual'
ax.YColor = 'k'
ax.YColorMode = 'manual'
ax.YGrid = 'on'
set(ax,'xticklabel',{"Best","Worst"})    
ax.YAxis.LineWidth=2.5
ax.XAxis.LineWidth=2.5
ax.YLim = [-10 110]
ax.YAxis.Label.String = 'Responses within +/-22.5° (%)';
ax.YAxis.Label.FontWeight = 'bold';
set(findobj(gca,'tag','Box'), 'Color', [0 0.5 0], 'LineWidth', 2);
ax.XAxis.Label.String = 'HRTF Set';
ax.XAxis.Label.FontWeight = 'bold';

