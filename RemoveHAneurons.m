function [t,ic] = RemoveHAneurons(t,ic,bs,be);
HAelec = FindHAelectrodes(t,ic,bs,be);
for i=1:numel(HAelec)
    [t,ic]=removeNeuronsWithoutPrompt(t,ic,[HAelec(i);1]);
end
end