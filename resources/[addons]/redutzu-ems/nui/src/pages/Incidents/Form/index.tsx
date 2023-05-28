import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

// Utils
import { showNotification } from '@mantine/notifications';
import { formatNumber, fetchNui } from '../../../utils/misc';

// Form
import { useFormik } from 'formik';
import schema from '../../../schemas/incidents';

// Components
import Form from '../../../components/Form';
import Input from '../../../components/Input';
import Textbox from '../../../components/Textbox';
import Autocomplete from '../../../components/Autocomplete';
import ImageZone from '../../../components/ImageZone';
import Button from '../../../components/Button';
import Slider from '../../../components/Slider';

const IncidentForm: React.FC = () => {
    const { t } = useTranslation('translation');
    const navigate = useNavigate();

    const [invoice_amount, setInvoice] = useState<number>(0);

    const { values, errors, touched, handleBlur, handleChange, handleSubmit } = useFormik({
        initialValues: {
            name: '',
            description: '',
            players: [],
            doctors: [],
            images: [],
            invoices: [],
            invoice_reduction: 0
        },
        validationSchema: schema,
        onSubmit: async (values) => {
            const data = {
                name: values.name,
                description: values.description,
                players: JSON.stringify(values.players.map((player: any) => ({
                    identifier: player.identifier,
                    firstname: player.firstname,
                    lastname: player.lastname,
                    phone_number: player.phone_number
                }))),
                doctors: JSON.stringify(values.doctors.map((cop: any) => ({
                    identifier: cop.identifier,
                    firstname: cop.firstname,
                    lastname: cop.lastname,
                    phone_number: cop.phone_number
                }))),
                images: JSON.stringify(values.images),
                invoices: JSON.stringify({
                    list: values.invoices,
                    amount: invoice_amount,
                    reduction: values.invoice_reduction
                })
            };

            let response = await fetchNui('create', { 
                type: 'incidents',
                event: 'incidents:create',
                data: data
            });

            if (!response.status) return showNotification({
                title: t('incidents.notification.error.title') as string,
                message: t('incidents.notification.error.message') as string,
                autoClose: 5000
            });

            showNotification({
                title: t('incidents.notification.success.title') as string,
                message: t('incidents.notification.success.message', { id: response.data }) as string,
                autoClose: 5000
            });
    
            return navigate(`/incident/${response.data}`);
        }
    });

    useEffect(() => {
        let invoice: number = values.invoices.reduce((total, invoice: any) => total + invoice.amount, 0);
        let total_invoice: number = invoice - (invoice * (values.invoice_reduction / 100));
        setInvoice(Math.floor(total_invoice));
    }, [values.invoices, values.invoice_reduction]);

    return (
        <Form onSubmit={handleSubmit} label={t('incidents.create')} autoComplete='off'>
            <Input 
                id='name'
                placeholder={t('incidents.name')}
                value={values.name}
                onBlur={handleBlur}
                onChange={handleChange}
                className={errors.name && touched.name ? 'input-error' : ''}
                error={errors.name && touched.name ? errors.name : ''}
            />
            
            <Textbox 
                id='description'
                placeholder={t('incidents.description')}
                value={values.description}
                onBlur={handleBlur}
                onChange={handleChange}
                className={errors.description && touched.description ? 'textbox-error' : ''}
                error={errors.description && touched.description ? errors.description : ''}
            />
            
            <Autocomplete
                input={{
                    id: 'players',
                    placeholder: t('incidents.players'),
                    className: errors.players && touched.players ? 'input-error' : '',
                    error: errors.players && touched.players ? errors.players : ''
                }}
                item={{ template: '{firstname} {lastname}', icon: 'fa-solid fa-user' }}
                result={{ template: '{firstname} {lastname}' }}
                identifier='identifier'
                table='players'
                onSelect={handleChange}
            />

            <Autocomplete 
                input={{
                    id: 'doctors',
                    placeholder: t('incidents.doctors'),
                    className: errors.doctors && touched.doctors ? 'input-error' : '',
                    error: errors.doctors && touched.doctors ? errors.doctors : ''
                }}
                item={{ template: '{firstname} {lastname}', icon: 'fa-solid fa-user-doctor' }}
                result={{ template: '{firstname} {lastname}' }}
                identifier='identifier'
                table='doctors'
                onSelect={handleChange}
            />
            

            {values.invoices.length ? (
                <Slider id='invoice_reduction' label={t('incidents.invoice_reduction', { amount: formatNumber(invoice_amount) })} onChange={handleChange} />
            ) : null}

            <Autocomplete 
                input={{
                    id: 'invoices',
                    placeholder: t('incidents.invoices')
                }}
                item={{ template: '{name}', icon: 'fa-solid fa-receipt' }}
                result={{ template: '{name} [=amount=$]' }}
                identifier='id'
                table='invoices'
                onSelect={handleChange}
            />
            
            <ImageZone
                id='images'
                value={values.images}
                onChange={handleChange}
                onBlur={handleBlur}
                error={errors.images}
                touched={touched.images}
            />

            <Button label={t('incidents.button')} type='submit' />
        </Form>
    );
}

export default IncidentForm;
