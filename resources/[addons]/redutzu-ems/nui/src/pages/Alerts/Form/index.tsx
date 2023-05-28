import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { showNotification } from '@mantine/notifications';

// Schema
import { useFormik } from 'formik';
import schema from '../../../schemas/alert';

// Components
import Form from '../../../components/Form';
import Input from '../../../components/Input';
import Textbox from '../../../components/Textbox';
import Button from '../../../components/Button';

// Utils
import { fetchNui } from '../../../utils/misc';

const AlertForm: React.FC = () => {
    const { t } = useTranslation('translation');
    const navigate = useNavigate();

    const { values, errors, touched, handleBlur, handleChange, handleSubmit } = useFormik({
        initialValues: {
            title: '',
            description: ''
        },
        validationSchema: schema,
        onSubmit: async (values) => {
            await fetchNui('CreateAlert', values);

            showNotification({ 
                title: t('alerts.notification.sent.title') as string,
                message: t('alerts.notification.sent.message') as string,
                autoClose: 5000
            });

            return navigate('/alerts');
        }
    });

    return (
        <Form onSubmit={handleSubmit} label={t('alerts.form')} autoComplete='off'>
            <Input 
                id='title'
                placeholder={t('alerts.name')}
                value={values.title}
                onBlur={handleBlur}
                onChange={handleChange}
                className={errors.title && touched.title ? 'input-error' : ''}
                error={errors.title && touched.title ? errors.title : ''}
            />
                        
            <Textbox 
                id='description'
                placeholder={t('alerts.description')}
                value={values.description}
                onBlur={handleBlur}
                onChange={handleChange}
                className={errors.description && touched.description ? 'textbox-error' : ''}
                error={errors.description && touched.description ? errors.description : ''}
            /> 
                        
            <Button label={t('alerts.button')} type='submit' />
        </Form>
    );
}

export default AlertForm;
