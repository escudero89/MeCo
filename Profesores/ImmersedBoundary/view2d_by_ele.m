function view2d_by_ele(xnod,icone,state)

%figure;clf;hold on

nen = size(icone,2);
for ele=1:size(icone,1)
    nodes = icone(ele,:);
    Xs=xnod(nodes,:);Xs=[Xs;Xs(1,:)];
    Us=state(ele,1)*ones(nen+1,1);
    patch(Xs(:,1),Xs(:,2),Us(:,1));
end