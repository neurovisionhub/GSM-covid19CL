I=aI_day_movil';
R=aR_day_movil';
F=aF_day_movil';
%[aF_day_movil] = mediamovil(F,ventana);
U=aU_day_movil';
global grafica_data 

%if interpolacion == 1
    vn = size(I,1);
    %percentPrunning = 0.01;
    dimFloat = percentPrunning*vn;
    dimceil = ceil(dimFloat);
    dimFloor = floor(dimFloat);
    %salto = size(I,1)/dimFloat
    salto = 1/(percentPrunning);
        
    original = dimFloat/percentPrunning;

    size(I,1);
    xV = ceil([1:salto:vn]); 
    x = [1:1:vn];
   
    y = I;
    px = spline(x,y,xV);
    I = px';
    y = U;
    px = spline(x,y,xV);
    U = px';    
    y = F;
    px = spline(x,y,xV);
    F = px';    
    y = R;
    px = spline(x,y,xV);
    R = px';
 grafica_data
    if grafica_data == 1
    figure;
    plot(x,aR_day_movil,'--',xV,R,'o')
    hold on
    plot(x,aI_day_movil,'--',xV,I,'o')
    plot(x,aF_day_movil,'--',xV,F,'x')
    plot(x,aU_day_movil,'--',xV,U,'o')
   
    
    
    if globalPais == 1 
        figure;
        plot(x,aF_day_movil,'--',xV,F,'x','DisplayName','Fallecidos Pais')
        hold on
        plot(x,aU_day_movil,'--',xV,U,'o','DisplayName','UCI País')
    else
        figure;
        plot(x,aF_day_movil,'--',xV,F,'x','DisplayName','Fallecidos Región')
        hold on
        plot(x,aU_day_movil,'--',xV,U,'o','DisplayName','UCI País')  
    end
    legend() 
    end