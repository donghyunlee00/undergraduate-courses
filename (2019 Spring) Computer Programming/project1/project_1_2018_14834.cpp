#include <iostream>
#include <vector>
#include <sstream>
#include <ctime>

using namespace std;

int energy, oxygenRate, dist, unitDist;
bool isSolarPanelDestroy, isArrive, isStop;

class Vehicle
{
public:
    void setEnvironment(string _environment) { environment = _environment; }
    void setUnit(int _unit) { unit = _unit; }
    void setMove_i(int _move) { move_i = _move; }
    void setMove(int _move) { move = _move; }
    void setSpeed(int _speed) { speed = _speed; }
    void setTemperature(int _temperature) { temperature = _temperature; }
    void setHumidity(int _humidity) { humidity = _humidity; }
    void setEnergyLoss()
    {
        energyLoss = 0;

        if (temperature == 0)
            energyLoss += 8;
        else if (temperature >= 40)
            energyLoss += 10;
        else
            energyLoss += 5;

        if (environment == "Car" || environment == "Airplane")
        {
            if (humidity < 50)
                energyLoss += 5;
            else
                energyLoss += 8;
        }

        energyLoss += light();
    }
    void setSpeedLoss(int _speedLoss) { speedLoss = _speedLoss; }
    void setOxygenRateLoss(int _oxygenRateLoss) { oxygenRateLoss = _oxygenRateLoss; }

    string getEnvironment() { return environment; }
    int getUnit() { return unit; }
    int getMove_i() { return move_i; }
    int getMove() { return move; }
    int getSpeed() { return speed - speedLoss; }
    int getTemperature() { return temperature; }
    int getHumidity() { return humidity; }
    int getEnergyLoss() { return energyLoss; }
    int getSpeedLoss() { return speedLoss; }
    int getOxygenRateLoss() { return oxygenRateLoss; }

    virtual void solarPanelRecharge() {}
    virtual int light() { return 0; }
    virtual void print() {}

private:
    string environment;
    int unit;
    int move_i;
    int move;
    int speed;
    int temperature;
    int humidity;
    int energyLoss;
    int speedLoss;
    int oxygenRateLoss;
};

class Car : public Vehicle
{
public:
    Car(int _move, int _temperature, int _humidity)
    {
        setEnvironment("Car");
        setUnit(50);
        setMove_i(_move);
        setSpeed(80);
        setTemperature(_temperature);
        setHumidity(_humidity);
        setEnergyLoss();
        setSpeedLoss(0);
        setOxygenRateLoss(0);
    }

    void solarPanelRecharge()
    {
        if (!isSolarPanelDestroy && getHumidity() < 50)
            energy = min(1000, energy + 200);
    }

    void print()
    {
        cout << "Current Status: Car" << endl;
        cout << "Distance: " << dist << " km" << endl;
        if (dist == 0)
            cout << "Speed: 0 km/hr" << endl;
        else
            cout << "Speed: " << getSpeed() << " km/hr" << endl;
        cout << "Energy: " << energy << endl;
        cout << "Temperature: " << getTemperature() << " C" << endl;
        cout << "Humidity: " << getHumidity() << endl;
    }
};

class Airplane : public Vehicle
{
public:
    Airplane(int _move, int _temperature, int _humidity, int _altitude, int _airDensity)
    {
        setEnvironment("Airplane");
        setUnit(1000);
        setMove_i(_move);
        setSpeed(900);
        setTemperature(_temperature);
        setHumidity(_humidity);
        altitude = _altitude;
        airDensity = _airDensity;
        setEnergyLoss();

        if (airDensity >= 70)
            setSpeedLoss(500);
        else if (airDensity >= 50)
            setSpeedLoss(300);
        else if (airDensity >= 30)
            setSpeedLoss(200);
        else
            setSpeedLoss(0);

        setOxygenRateLoss(altitude / 100);
    }

    void print()
    {
        cout << "Current Status: Airplane" << endl;
        cout << "Distance: " << dist << " km" << endl;
        cout << "Speed: " << getSpeed() << " km/hr" << endl;
        cout << "Energy: " << energy << endl;
        cout << "Oxygen Level: " << oxygenRate << endl;
        cout << "Temperature: " << getTemperature() << " C" << endl;
        cout << "Humidity: " << getHumidity() << endl;
        cout << "Altitude: " << altitude << " m" << endl;
        cout << "Air Density: " << airDensity << endl;
    }

private:
    int altitude;
    int airDensity;
};

class Submarine : public Vehicle
{
public:
    Submarine(int _move, int _temperature, int _depth, int _waterFlow)
    {
        setEnvironment("Submarine");
        setUnit(10);
        setMove_i(_move);
        setSpeed(20);
        setTemperature(_temperature);
        setHumidity(100);
        depth = _depth;
        waterFlow = _waterFlow;
        setEnergyLoss();

        if (waterFlow >= 70)
            setSpeedLoss(10);
        else if (waterFlow >= 50)
            setSpeedLoss(5);
        else if (waterFlow >= 30)
            setSpeedLoss(3);
        else
            setSpeedLoss(0);

        setOxygenRateLoss(depth / 10);
    }

    int light() { return 30; }

    void print()
    {
        cout << "Current Status: Submarine" << endl;
        cout << "Distance: " << dist << " km" << endl;
        cout << "Speed: " << getSpeed() << " km/hr" << endl;
        cout << "Energy: " << energy << endl;
        cout << "Oxygen Level: " << oxygenRate << endl;
        cout << "Temperature: " << getTemperature() << " C" << endl;
        cout << "Depth: " << depth << " m" << endl;
        cout << "Water Flow: " << waterFlow << endl;
    }

private:
    int depth;
    int waterFlow;
};

class X : public Vehicle
{
public:
    X() { setEnvironment("X"); }
};

class Y : public Vehicle
{
public:
    Y() { setEnvironment("Y"); }
};

struct TestCase
{
    vector<Vehicle *> v;
    int totalDist;
    string textGraphic_i;
    string textGraphic;
    string TC;
} tc[11];

struct Blackbox
{
    vector<string> environment;
    vector<int> energyLevel;
    vector<int> oxygenLevel;
    vector<int> speed;
};

void readTC();
void simulate(int modeSelect, int n, Blackbox *blackbox);
void recordBlackbox(string environment, int speed, Blackbox *blackbox);
void printFinish(int n, Blackbox *blackbox);

int main()
{
    tc[1].TC = "[R150T20H30],[S3000T10H5A1000D20],[O30T0D50W100],[R150T20H30],[X],[S3000T10H5A1000D20],[O30T0D50W100]";
    tc[2].TC = "[R150T20H30],[O80T0D50W100],[R150T20H60],[Y],[O80T0D50W100],[R150T20H30]";
    tc[3].TC = "[R150T20H30],[O80T0D50W100],[Y],[S3000T10H5A1000D20]";
    tc[4].TC = "[R150T70H30],[S3000T70H70A1000D20],[O30T70D50W100],[R2000T70H60],[S4000T70H70A1000D20]";
    tc[5].TC = "[R150T70H30],[S3000T70H70A1000D20],[O30T70D50W100],[R2000T70H60],[X],[S4000T70H70A1000D20]";
    tc[6].TC = "[R150T20H30],[S3000T10H5A1000D20],[O30T0D50W100],[R3000T70H70]";
    tc[7].TC = "[R150T20H30],[S4000T10H5A4000D20],[O30T0D50W100]";
    tc[8].TC = "[R150T70H30],[S3000T70H70A1000D20],[O30T70D50W100],[R2000T70H60],[S8000T70H70A1000D20]";
    tc[9].TC = "[R150T20H30],[S3000T10H5A1000D20],[O60T0D200W100]";
    tc[10].TC = "[R150T70H70],[S3000T70H70A1000D20],[O50T70D50W100],[R2000T70H70],[O80T70D50W100]";

    readTC();

    cout << "PJ1.LDH.2018-14834" << endl;
    cout << "Mode Select(1 for EXTRA, 2 for NORMAL) : ";
    int modeSelect;
    cin >> modeSelect;

    while (true)
    {
        cout << "Choose the number of the test case (1~10) : ";
        int n;
        cin >> n;

        if (n == 0)
            return 0;

        energy = 1000;
        oxygenRate = 100;
        dist = 0;
        unitDist = 1;
        isSolarPanelDestroy = false;
        isArrive = false;
        isStop = false;

        struct Blackbox blackbox;

        simulate(modeSelect, n, &blackbox);

        printFinish(n, &blackbox);
    }

    return 0;
}

void readTC()
{
    for (int i = 1; i <= 10; i++)
    {
        tc[i].textGraphic_i = "|@";

        stringstream ss(tc[i].TC);
        while (ss.good())
        {
            string substr;
            char cstr[3000];
            getline(ss, substr, ',');
            strcpy(cstr, substr.c_str());

            vector<char *> value;

            char *pch = strtok(cstr, "[]RSOTHADWXY");
            while (pch != NULL)
            {
                value.push_back(pch);
                pch = strtok(NULL, "[]RSOTHADWXY");
            }

            if (substr[1] == 'R')
            {
                tc[i].v.push_back(new Car(atoi(value[0]), atoi(value[1]), atoi(value[2])));
                for (int j = 0; j < atoi(value[0]) / 50; j++)
                    tc[i].textGraphic_i += "=";
            }
            else if (substr[1] == 'S')
            {
                tc[i].v.push_back(new Airplane(atoi(value[0]), atoi(value[1]), atoi(value[2]), atoi(value[3]), atoi(value[4])));
                for (int j = 0; j < atoi(value[0]) / 1000; j++)
                    tc[i].textGraphic_i += "^";
            }
            else if (substr[1] == 'O')
            {
                tc[i].v.push_back(new Submarine(atoi(value[0]), atoi(value[1]), atoi(value[2]), atoi(value[3])));
                for (int j = 0; j < atoi(value[0]) / 10; j++)
                    tc[i].textGraphic_i += "~";
            }
            else if (substr[1] == 'X')
                tc[i].v.push_back(new X());
            else if (substr[1] == 'Y')
                tc[i].v.push_back(new Y());

            if (value.size() != 0)
                tc[i].totalDist += atoi(value[0]);
        }

        tc[i].textGraphic_i += "|";
    }
}

void simulate(int modeSelect, int n, Blackbox *blackbox)
{
    cout << "Test case #" << n << ".\n\n";
    tc[n].v[0]->print();
    tc[n].textGraphic = tc[n].textGraphic_i;
    cout << tc[n].textGraphic << endl;

    for (int i = 0; i < tc[n].v.size(); i++)
    {
        string environment = tc[n].v[i]->getEnvironment();

        if (environment == "X" || environment == "Y")
        {
            if (modeSelect == 2)
                continue;

            srand((unsigned int)time(NULL));

            if (environment == "X")
            {
                if (rand() % 100 < 20)
                {
                    isStop = true;
                    cout << "Successfully moved to next 0 km" << endl;
                    return;
                }
                else
                {
                    energy = max(energy - 100, 0);
                    if (energy == 0)
                    {
                        cout << "Successfully moved to next 0 km" << endl;
                        return;
                    }
                }
            }
            else
            {
                if (rand() % 100 < 35)
                {
                    isStop = true;
                    cout << "Successfully moved to next 0 km" << endl;
                    return;
                }
                else if (rand() % 100 < 50)
                {
                    if (tc[n].v[i - 1]->getEnvironment() == "Car")
                        isSolarPanelDestroy = true;
                    else
                    {
                        oxygenRate = max(oxygenRate - 30, 0);
                        if (oxygenRate == 0)
                        {
                            cout << "Successfully moved to next 0 km" << endl;
                            return;
                        }
                    }
                }
            }

            continue;
        }

        if (environment == "Car")
        {
            tc[n].v[i]->solarPanelRecharge();
            oxygenRate = 100;
        }

        tc[n].v[i]->setMove(tc[n].v[i]->getMove_i());

        while (tc[n].v[i]->getMove() > 0)
        {
            cout << "Next Move? (1,2)" << endl;
            cout << "CP-2018-14834> ";
            int mode;
            cin >> mode;

            int unit = tc[n].v[i]->getUnit();
            int totalUnit = 0;

            do
            {
                dist += unit;
                tc[n].v[i]->setMove(tc[n].v[i]->getMove() - unit);
                energy = max(energy - tc[n].v[i]->getEnergyLoss(), 0);
                oxygenRate = max(oxygenRate - tc[n].v[i]->getOxygenRateLoss(), 0);
                totalUnit += unit;
            } while (mode == 2 && tc[n].v[i]->getMove() > 0 && energy > 0 && oxygenRate > 0);

            cout << "Successfully moved to next " << totalUnit << " km" << endl;

            for (int j = 0; j < totalUnit / unit; j++)
                tc[n].textGraphic[unitDist + j] = tc[n].textGraphic[unitDist + j + 1];
            unitDist += totalUnit / unit;
            tc[n].textGraphic[unitDist] = '@';

            if (dist == tc[n].totalDist || energy == 0 || oxygenRate == 0)
            {
                if (dist == tc[n].totalDist)
                    isArrive = true;
                recordBlackbox(environment, tc[n].v[i]->getSpeed(), blackbox);
                return;
            }

            tc[n].v[i]->print();
            cout << tc[n].textGraphic << endl;
        }

        recordBlackbox(environment, tc[n].v[i]->getSpeed(), blackbox);
    }
}

void recordBlackbox(string environment, int speed, Blackbox *blackbox)
{
    blackbox->environment.push_back(environment);
    blackbox->energyLevel.push_back(energy);
    blackbox->oxygenLevel.push_back(oxygenRate);
    blackbox->speed.push_back(speed);
}

void printFinish(int n, Blackbox *blackbox)
{
    cout << "Final Status:" << endl;
    cout << "Distance: " << dist << " km" << endl;
    cout << "Energy: " << energy << endl;
    cout << "Oxygen Level: " << oxygenRate << endl;
    cout << tc[n].textGraphic << endl;

    cout << "\n!FINISHED : ";
    if (isStop)
        cout << "Vehicle stop" << endl;
    else if (isArrive)
        cout << "Arrived" << endl;
    else if (energy == 0)
        cout << "Energy failure" << endl;
    else if (oxygenRate == 0)
        cout << "Oxygen failure" << endl;

    cout << "Blackbox: " << endl;
    cout << "Mode: " << blackbox->environment[0];
    for (int i = 1; i < blackbox->environment.size(); i++)
        cout << " > " << blackbox->environment[i];
    cout << "\nEnergy Level: " << blackbox->energyLevel[0];
    for (int i = 1; i < blackbox->energyLevel.size(); i++)
        cout << " > " << blackbox->energyLevel[i];
    cout << "\nOxygen Level: " << blackbox->oxygenLevel[0];
    for (int i = 1; i < blackbox->oxygenLevel.size(); i++)
        cout << " > " << blackbox->oxygenLevel[i];
    cout << "\nSpeed: " << blackbox->speed[0];
    for (int i = 1; i < blackbox->speed.size(); i++)
        cout << " > " << blackbox->speed[i];
    cout << "\n-------------------------" << endl;
}