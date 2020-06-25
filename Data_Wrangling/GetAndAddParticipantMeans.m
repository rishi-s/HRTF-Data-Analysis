function[ParticipantMeans]=GetAndAddParticipantMeans(meanData,source,type)
%GETANDADDPARTICIPANTMEANS Summary of this function goes here
%   Detailed explanation goes here

% For each participant
for i=1:22
    % Reset the counter and storage array
    counter=1;
    TimeStorage=zeros(1,18,22);
    % Loop through the song variable first
    for j=1:length(source.Participant)
        % If it is current right participant
        if source.Participant(j)==meanData.Participant(i)
            % List this in the array
            TimeStorage(counter,1,i)=(i);
            % Check the song variable status ...
            switch(source.Songs(j))
                % ... then lookup and append the relevant time.
                case 1;
                    TimeStorage(counter,2,i)=source.Time(j);
                case 2;
                    TimeStorage(counter,3,i)=source.Time(j);
                case 3;
                    TimeStorage(counter,4,i)=source.Time(j);                    
                case 4;
                    TimeStorage(counter,5,i)=source.Time(j);                    
            end            
            % Check the visual guidance variable status ...
            switch (source.Visuals(j))
                % ... then lookup and append the relevant time.
                case 0;
                    TimeStorage(counter,6,i)=source.Time(j);
                case 1;
                    TimeStorage(counter,7,i)=source.Time(j);
            end
            % Check the visual guidance exposure order variable status ...
            switch (source.VisOrder(j))
                % ... then lookup and append the relevant time.
                case 1;
                    TimeStorage(counter,8,i)=source.Time(j);
                case 2;
                    TimeStorage(counter,9,i)=source.Time(j);
            end
            % If a browse task, check the browse task type ...
            if type==1;
                switch (source.TaskSplit2(j))
                    % ... then lookup and append the relevant time.
                    case "youlike.";
                        TimeStorage(counter,10,i)=source.Time(j);
                    case "youdonotlike.";
                        TimeStorage(counter,11,i)=source.Time(j);
                    case "hasastrongbeat.";
                        TimeStorage(counter,12,i)=source.Time(j);
                    case "youwouldlistentoonyourmorningcommute.";
                        TimeStorage(counter,13,i)=source.Time(j);
                    case "youwouldlistentoatthegym.";
                        TimeStorage(counter,14,i)=source.Time(j);                    
                end
                switch (source.Genre(j))
                    % ... then lookup and append the relevant time.
                    case "hiphop";
                        TimeStorage(counter,15,i)=source.Time(j);
                    case "jazz";
                        TimeStorage(counter,16,i)=source.Time(j);
                    case "rock";
                        TimeStorage(counter,17,i)=source.Time(j);
                    case "mixed";
                        TimeStorage(counter,18,i)=source.Time(j);                   
                end
            end
            counter=counter+1;
        end
    end
    ParticipantMeans(i,1)=i;
    ParticipantMeans(i,2)=mean(nonzeros(TimeStorage(:,2,i)));
    ParticipantMeans(i,3)=mean(nonzeros(TimeStorage(:,3,i)));
    ParticipantMeans(i,4)=mean(nonzeros(TimeStorage(:,4,i)));
    ParticipantMeans(i,5)=mean(nonzeros(TimeStorage(:,5,i)));
    ParticipantMeans(i,6)=mean(nonzeros(TimeStorage(:,6,i)));
    ParticipantMeans(i,7)=mean(nonzeros(TimeStorage(:,7,i)));
    ParticipantMeans(i,8)=mean(nonzeros(TimeStorage(:,8,i)));
    ParticipantMeans(i,9)=mean(nonzeros(TimeStorage(:,9,i)));
    ParticipantMeans(i,10)=mean(nonzeros(TimeStorage(:,10,i)));
    ParticipantMeans(i,11)=mean(nonzeros(TimeStorage(:,11,i)));
    ParticipantMeans(i,12)=mean(nonzeros(TimeStorage(:,12,i)));
    ParticipantMeans(i,13)=mean(nonzeros(TimeStorage(:,13,i)));
    ParticipantMeans(i,14)=mean(nonzeros(TimeStorage(:,14,i)));
    ParticipantMeans(i,15)=mean(nonzeros(TimeStorage(:,15,i)));
    ParticipantMeans(i,16)=mean(nonzeros(TimeStorage(:,16,i)));
    ParticipantMeans(i,17)=mean(nonzeros(TimeStorage(:,17,i)));
    ParticipantMeans(i,18)=mean(nonzeros(TimeStorage(:,18,i)));
end

