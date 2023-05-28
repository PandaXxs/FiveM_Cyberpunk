import React from 'react';
import { useQuery } from 'react-query';
import { Trans, useTranslation } from 'react-i18next';
import { useNavigate, useParams } from 'react-router-dom';
import { showNotification } from '@mantine/notifications';
import { fetchNui } from '../../utils/misc';
import { fromNow } from '../../utils/date';

// Form
import { useFormik } from 'formik';
import schema from '../../schemas/invoices';

// Components
import Page from '../../components/Page';
import Form from '../../components/Form';
import Input from '../../components/Input';
import FormattedInput from '../../components/FormattedInput';
import Tooltip from '../../components/Tooltip';

// Assets
import './styles.scss';

const Invoice: React.FC = () => {
    const { t } = useTranslation('translation');
    const parameters = useParams();
    const navigate = useNavigate();

    const { isLoading, data } = useQuery(['invoice', parameters.id], () =>
        fetchNui('search', {
            type: 'invoice',
            query: parameters.id,
            single: true
        })
        .then(data => data)
    )

    const id = !isLoading ? data.id : '0';
    const name = !isLoading ? data.name : 'Loading...';
    const amount = !isLoading ? data.amount : 0;
    const createdAt = !isLoading ? data.createdAt : null;

    const { values, errors, touched, handleBlur, handleChange, submitForm } = useFormik({
        initialValues: { name, amount },
        validationSchema: schema,
        enableReinitialize: true,
        onSubmit: async (values) => {
            let request = fetchNui('update', {
                type: 'invoice',
                id: id,
                values: {
                    name: values.name,
                    amount: values.amount
                },
                event: 'invoices:update'
            });

            request.then(response => {
                if (!response.status) return;
                
                showNotification({
                    title: t('invoices.notification.update.title') as string,
                    message: t('invoices.notification.update.message', { id }) as string,
                    autoClose: 5000
                });
    
                return navigate('/invoices');
            });
        }
    });

    return (
        <Page header={{
            title: t('invoices.invoice.title', { id: id }),
            subtitle: t('invoices.invoice.subtitle', { date: fromNow(createdAt) }),
            backable: true
        }}>
            <div className='invoice'>
                <div className='invoice-icon'>
                    <i className='fa-solid fa-receipt'></i>
                    <h1>{name}</h1>
                </div>
                <div className='invoice-information'>
                    <div className='title'>
                        <Tooltip text={t('common.tooltip.save')} position='right'>
                            <h1><Trans t={t}>words.information</Trans></h1>
                        </Tooltip>
                        <i className='fa-solid fa-floppy-disk' onClick={submitForm}></i>
                    </div>
                    <div className='data'>
                        <Form autoComplete='off'>
                            <Input
                                id='name'
                                placeholder={t('words.name')}
                                value={values.name}
                                onBlur={handleBlur}
                                onChange={handleChange}
                                className={errors.name && touched.name ? 'input-error' : ''}
                                error={errors.name && touched.name ? errors.name as string : ''}
                            />

                            <FormattedInput 
                                id='amount'
                                placeholder={t('words.amount')}
                                value={values.amount}
                                onBlur={handleBlur}
                                change={handleChange}
                                className={errors.amount && touched.amount ? 'input-error' : ''}
                                error={errors.amount && touched.amount ? errors.amount as string : ''}
                                format='number'
                                format_options={{
                                    liveUpdate: true
                                }}
                            />
                        </Form>
                    </div>
                </div>
            </div>
        </Page>
    );
}

export default Invoice;
