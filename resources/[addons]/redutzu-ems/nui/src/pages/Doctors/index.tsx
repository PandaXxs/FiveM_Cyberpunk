import React from 'react';
import { useQuery } from 'react-query';
import { useTranslation } from 'react-i18next';
import { fetchNui } from '../../utils/misc';

// Components
import Page from '../../components/Page';
import Container from './Container';

// Assets
import './styles.scss';

const Doctors: React.FC = () => {
    const { t } = useTranslation('translation');

    const { isLoading, data } = useQuery('doctors', () =>
        fetchNui('GetDoctors')
            .then(data => data)
    )

    let offline = !isLoading ? data.filter((item: any) => !item.online) : [];
    let online = !isLoading ? data.filter((item: any) => item.online) : [];

    return (
        <Page header={{ title: t('doctors.title'), subtitle: t('doctors.subtitle') }}>
            { online.length || offline.length ? (
                <div className='doctors-container'>
                    <Container label={t('words.online')} items={online} />
                    <Container label={t('words.offline')} items={offline} />
                </div>
            ) : (
                <div className='no-doctors'>
                    <i className='fa-solid fa-user-slash'></i>
                </div>
            )}
        </Page>
    );
}

export default Doctors;
