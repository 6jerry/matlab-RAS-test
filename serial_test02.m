stest=rc9_serial;
stest.connect("COM3");
test_datas=single([233.7,233.8,233.9,233.88]);

while true

    stest.serialsend(test_datas,1);
    pause(0.05);
    test_datas(1)= test_datas(1)+0.001;

end
