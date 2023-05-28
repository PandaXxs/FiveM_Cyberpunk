import React from 'react';
import { useQuery } from 'react-query';
import { showNotification } from '@mantine/notifications';
import { useNavigate, useParams } from 'react-router-dom';
import { useTranslation, Trans } from 'react-i18next';
import { fetchNui, formatNumber } from '../../utils/misc';
import { fromNow } from '../../utils/date';

// Form
import { useFormik } from 'formik';
import schema from '../../schemas/incident';

// Components
import Page from '../../components/Page';
import TextBox from '../../components/Textbox';
import Tooltip from '../../components/Tooltip';
import SimpleList from '../../components/SimpleList';

// Assets
import './styles.scss';

const Incident: React.FC = () => {
    const { t } = useTranslation('translation');
    const navigate = useNavigate();
    const parameters = useParams();

    const { isLoading, data } = useQuery(['incident', parameters.id], () =>
        fetchNui('search', {
            type: 'incident',
            query: parameters.id,
            single: true
        })
        .then(data => data)
    )

    const id = !isLoading ? data.id : 'Loading...';
    const name = !isLoading ? data.name : 'Loading...';
    const description = !isLoading ? data.description : 'Loading...';
    const players = !isLoading ? JSON.parse(data.players) : [];
    const doctors = !isLoading ? JSON.parse(data.doctors) : [];
    const images = !isLoading ? JSON.parse(data.images) : [];
    const invoices = !isLoading ? JSON.parse(data.invoices) : { amount: 0, reduction: 0, list: [] };
    const createdAt = !isLoading ? data.createdAt : null;

    const { values, handleBlur, handleChange, submitForm } = useFormik({
        initialValues: { description },
        validationSchema: schema,
        enableReinitialize: true,
        onSubmit: async (values) => {
            let request = fetchNui('update', {
                type: 'incident',
                id: parameters.id,
                values: {
                    description: values.description
                },
                event: 'incidents:update'
            });

            request.then(response => {
                if (!response.status) return;
                
                showNotification({
                    title: t('incidents.notification.update.title') as string,
                    message: t('incidents.notification.update.message', { id }) as string,
                    autoClose: 5000
                });
    
                return navigate('/incidents');
            });
        }
    });

    return (
        <Page header={{
            title: t('incidents.incident.title', { id }),
            subtitle: t('incidents.incident.subtitle', { date: fromNow(createdAt) }),
            backable: true
        }}>
            <div className='incident'>
                <div className='info'>
                    <i className='fa-solid fa-shield-halved'></i>
                    <h1>{name}</h1>
                </div>
                <div className='description'>
                    <div className='title'>
                        <Tooltip text={t('incidents.tooltip.description')} position='right'>
                            <h1><Trans t={t}>incidents.description</Trans></h1>
                        </Tooltip>
                        <i className='fa-solid fa-floppy-disk' onClick={submitForm}></i>
                    </div>
                    <TextBox
                        id='description'
                        onChange={handleChange}
                        onBlur={handleBlur}
                        value={values.description}
                    />
                </div>
                <div className='body'>
                    <SimpleList
                        label={t('incidents.players')}
                        results={players}
                        icon='fa-solid fa-user'
                        main_template='{firstname} {lastname}'
                        secondary_template='{phone_number}'
                        redirect='/citizen/{identifier}'
                    />

                    <SimpleList
                        label={t('incidents.doctors')}
                        results={doctors}
                        icon='fa-solid fa-user'
                        main_template='{firstname} {lastname}'
                        secondary_template='{phone_number}'
                        redirect='/citizen/{identifier}'
                    />

                    <SimpleList
                        label={t('incidents.invoice_full', { amount: formatNumber(invoices.amount), reduction: invoices.reduction ? `(${invoices.reduction}% ${t('incidents.reducted')})` : '' })}
                        results={invoices.list}
                        icon='fa-solid fa-receipt'
                        main_template='{name}'
                        secondary_template='=amount=$'
                    />
                    <div className='images-container'>
                        {
                            images.map((image: string, index: number) => (
                                <div className='image' key={index}>
                                    <img src={image} alt='incident-image' />
                                </div>
                            ))
                        }
                    </div>
                </div>
            </div>
        </Page>
    );
}

export default Incident;
