function [salida,sn] = ajusteHeuristicoAcum(input,inputSortPais, titulo) 
for k =1:size(input,1)
    i = size(input,2);   
 
    while i>1             
        if input(k,i-1) > input(k,i)
           input(k,i-1) = input(k,i);
           %j=j+1
           i=i-1;
        else
           %j=1
           %input(k,i-1) =  input(k,i)
           i=i-1 ;
        end
    end
    
end
FpaisDiff =[];
FpaisDiffNormLocal =[];
tmp = [];
for k =1:size(input,1)
 
    FpaisDiff = [FpaisDiff;diff(input(k,:))]; 
end

 inicioN=1;
for k =1:size(input,1)
    tmp0 = diff(input(k,inicioN:end))./max(diff(input(k,inicioN:end)));
    FpaisDiffNormLocal = [FpaisDiffNormLocal; tmp0] ; 
    
   % FpaisDiffNormLocal = [FpaisDiffNormLocal; diff(input(k,inicioN:end))./max(diff(input(k,inicioN:end)))     ] ;
end


 figure
 surf(input)
 title('input acumulados ajuste heuristico -')
 figure        
 surf(input./max(input(:,end)))
 title('input acumulados ajuste input/max(input) -')
  figure        
 surf(FpaisDiff)
  figure      
  
 
 surf(FpaisDiffNormLocal(:,inicioN:end))
  title('input acumulados ajuste FpaisDiff./max(FpaisDiff) - 0')
  
  figure;imagesc((FpaisDiffNormLocal(:,inicioN:end)));
  
  figure       
 mesh(FpaisDiffNormLocal(:,inicioN:end))
  title('input acumulados ajuste FpaisDiff./max(FpaisDiff) -')
 salida = input;   
 sn=FpaisDiffNormLocal;
end