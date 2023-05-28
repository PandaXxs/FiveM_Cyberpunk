import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { showNotification } from '@mantine/notifications';
import { fetchNui } from '../../utils/misc';

// Components
import Page from '../../components/Page';
import List from '../../components/List';
import Form from './Form';

const Invoices: React.FC = () => {
    const { t } = useTranslation('translation');
    const navigate = useNavigate();

    return (
        <Page header={{ title: t('invoices.title'), subtitle: t('invoices.subtitle') }}>
            <div className='half-grid'>
                <List
                    table='invoices'
                    icon='fa-solid fa-receipt'
                    label={t('invoices.form')}
                    name_template='{name}'
                    info_template='(~createdAt~)'
                    onClick={item => navigate(`/invoice/${item.id}`)}
                    sort={(a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()}
                    contextMenu={{
                        enabled: true,
                        title: t('invoices.modal.delete.title'),
                        description: t('invoices.modal.delete.message'),
                        icon: 'fa-solid fa-trash-can',
                        onConfirm: item => {
                            let request = fetchNui('delete', {
                                type: 'invoices',
                                id: item.id,
                                event: 'invoices:delete'
                            });

                            return request.then(() => {
                                showNotification({
                                    title: t('invoices.notification.delete.title') as string,
                                    message: t('invoices.notification.delete.message', { id: item.id }) as string,
                                    autoClose: 5000
                                });

                                return navigate('/invoices');
                            });
                        }
                    }}
                />
                
                <Form />
            </div>
        </Page>
    );
}

export default Invoices;
