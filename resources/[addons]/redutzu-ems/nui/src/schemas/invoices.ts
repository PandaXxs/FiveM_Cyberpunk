import * as yup from 'yup';

const schema = yup.object().shape({
    name: yup.string().required('errors.invoices.name.required'),
    amount: yup.number().required('errors.invoices.amount.required')
});

export default schema;