import React from 'react';
import { useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import { showNotification } from '@mantine/notifications';
import { fetchNui } from '../../../utils/misc';

import CONFIG from '../../../config';

// Form
import { useFormik } from 'formik';
import schema from '../../../schemas/invoices';

// Components
import Form from '../../../components/Form';
import Input from '../../../components/Input';
import FormattedInput from '../../../components/FormattedInput';
import Button from '../../../components/Button';

// Assets
import './styles.scss';

const InvoicesForm: React.FC = () => {
    const { t } = useTranslation('translation');
    const navigate = useNavigate();

    const { values, errors, touched, handleBlur, handleChange, handleSubmit } = useFormik({
        initialValues: {
            name: '',
            amount: ''
        },
        validationSchema: schema,
        onSubmit: async (values) => {
            let response = await fetchNui('create', { 
                type: 'invoices',
                event: 'invoices:create',
                data: values
            });

            if (!response.status) return showNotification({
                title: t('invoices.notification.error.title') as string,
                message: t('invoices.notification.error.message') as string,
                autoClose: 5000
            });

            showNotification({
                title: t('invoices.notification.success.title') as string,
                message: t('invoices.notification.success.message', { id: response.data }) as string,
                autoClose: 5000
            });

            return navigate(`/invoice/${response.data}`);
        }
    });

    return (
        <Form onSubmit={handleSubmit} label={t('invoices.create')} autoComplete='off'>
            <Input 
                id='name'
                placeholder={t('invoices.name')}
                value={values.name}
                onBlur={handleBlur}
                onChange={handleChange}
                className={errors.name && touched.name ? 'input-error' : ''}
                error={errors.name && touched.name ? errors.name : ''}
            />

            <FormattedInput
                id='amount'
                placeholder={t('invoices.amount')}
                onBlur={handleBlur}
                change={handleChange}
                className={errors.amount && touched.amount ? 'input-error' : ''}
                error={errors.amount && touched.amount ? errors.amount : ''}
                format='currency'
                format_options={{
                    locale: CONFIG.DEFAULT_LOCALE,
                    currency: CONFIG.CURRENCY,
                    maxDecimals: 2,
                    liveUpdate: true
                }}
            />

            <Button label={t('invoices.button')} type='submit' />
        </Form>
    );
}

export default InvoicesForm;
