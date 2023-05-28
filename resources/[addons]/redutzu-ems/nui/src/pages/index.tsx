import React, { useState } from 'react';
import { MemoryRouter, Route } from 'react-router-dom';
import { NotificationsProvider } from '@mantine/notifications';
import { QueryClient, QueryClientProvider } from 'react-query';

import CONFIG from '../config';

// Types
import Modal from '../types/modal';

// Context
import ModalContext from '../contexts/Modal';

// Components
import Container from '../components/Container';
import Navigation from '../components/Navigation';
import Wrapper from '../components/Wrapper';
import Modals from '../components/Modals';

// Pages
import Alerts from './Alerts';
import Citizen from './Citizen';
import Citizens from './Citizens';
import Code from './Code';
import Codes from './Codes';
import Configuration from './Configuration';
import Dashboard from './Dashboard';
import Invoice from './Invoice';
import Invoices from './Invoices';
import Incident from './Incident';
import Incidents from './Incidents';
import Doctors from './Doctors';

const client = new QueryClient();

const App: React.FC = () => {
  const [modals, setModals] = useState<Modal[]>([]);
  const createModal = (modal: Modal) => setModals((modals) => [...modals, modal]);

  return (
    <MemoryRouter>
      <QueryClientProvider client={client}>
        <ModalContext.Provider value={{ createModal }}>
          <NotificationsProvider position='top-right'>
            <Container>
              <Modals modals={modals} setModals={setModals} />
              <Navigation links={CONFIG.PAGES} />

              <Wrapper>
                <Route path='/' element={<Dashboard />} />
                <Route path='/incidents' element={<Incidents />} />
                <Route path='/incident/:id' element={<Incident />} />
                <Route path='/doctors' element={<Doctors />} />
                <Route path='/alerts' element={<Alerts />} />
                <Route path='/citizens' element={<Citizens />} />
                <Route path='/citizen/:identifier' element={<Citizen />} />
                <Route path='/invoice/:id' element={<Invoice />} />
                <Route path='/invoices' element={<Invoices />} />
                <Route path='/codes' element={<Codes />} />
                <Route path='/code/:id' element={<Code />} />
                <Route path='/config' element={<Configuration />} />
              </Wrapper>
            </Container>
          </NotificationsProvider>
        </ModalContext.Provider>
      </QueryClientProvider>
    </MemoryRouter>
  )
}

export default App;
