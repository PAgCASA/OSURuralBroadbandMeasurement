# 2022 OSU Capstone Project: Rural Broadband Internet Testing

This is all the code for the 2022 OSU Capstone Project: Rural Broadband Internet Testing

We used:
- Flutter
- Golang (with Fiber as the web framework)
- Ansible
- HTTP JSON API

Our repo can be found @ https://github.com/PAgCASA/OSURuralBroadbandMeasurement where it is publicly available

We still need to do more work in order to integrate the public dashboard API that will provide additional data to the public as they request it. We also need a more fully formed administrative dashboard.

## Backend
The backend is written in Golang using the Fiber framework.

The `internal` folder contains all the internal utilities used by the code, broken into sections such as `database`, `types` and `testing`. These generally should be able to be unit-tested and are self-contained

The `cmd` folder contains the actual server code, broken into `main.go` and `udp.go`. This is harder to test and contains the actual meat of the application. There is also more logic, and singletons in this space.

## Frontend
The frontend is written in Flutter (Dart) and because it makes use of many libraries, has very limited native code.

The `lib` folder contains most of the relevant source code broken up by file into the individual screens. Each page is generally self-contained and is well broken down into functions.

Each component of the front end is designed to scale according to the dimensions of the phone. The text will function the same, but the buttons will be too large for the screen if the dimensions of the screen are too small.

There are four total screens which compose the front end of the application.
- The Home Page
- The Run Test Page
- The Test Results Page
- The Upload Profile Information Page

## Infrastructure
Our infrastructure is created using Ansible, which allows us to reliably reproduce our infra regardless of it's initial state.

There is additional documentation in that folder, which is self-documenting, meaning it follows a very clear pattern as outlined in the "Ansible Boilerplate" repository.

The most common command used is `ansible-playbook -i hosts allInOne.yml --ask-vault-password` run from the `infra` folder. This will ask for the vault password (included in the handoff zip folder) and then deploy to the AWS server, including both the database and the actual application on the same server.

Within the `infra` folder, it is broken down into separate folders for each role, which can be run and tested independently.